class Patinae < Formula
  include Language::Python::Virtualenv

  desc "Fast, programmable molecular viewer for research, scripting, and the web"
  homepage "https://zmactep.github.io/pymol-rs/"
  url "https://github.com/zmactep/pymol-rs/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "52f2d341f73ef8f2da33c95ae44dbc1f17e6baba57b9cbe8d569a48d4bdf0b4e"
  license "BSD-3-Clause"
  head "https://github.com/zmactep/pymol-rs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on :macos
  depends_on "python@3.13"

  def install
    python = Formula["python@3.13"].opt_bin/"python3.13"
    ENV["PYO3_PYTHON"] = python

    system "cargo", "install", *std_cargo_args(root: libexec, path: "patinae")
    # Plugins
    system "cargo", "build", "--release", "--locked", "--lib",
           "-p", "raytracer-plugin",
           "-p", "hello-plugin",
           "-p", "ipc-plugin",
           "-p", "python-plugin"
    (libexec/"plugins").install Dir["target/release/lib*_plugin.dylib"]

    venv = virtualenv_create(libexec/"venv", python)
    # No --locked here: python/ is a standalone crate (outside the workspace)
    # whose lockfile maturin resolves separately, and the tagged tarball's
    # python/Cargo.lock is not fully in sync with its manifest.
    system "maturin", "build", "--release",
           "--manifest-path", "python/Cargo.toml",
           "--interpreter", python,
           "--out", buildpath/"wheels"
    venv.pip_install Dir[buildpath/"wheels/patinae-*.whl"].first

    if OS.mac?
      # Generate AppIcon.icns from images/patinae.png (uses sips + python3).
      system "make", "icon"
      libexec.install "target/app/AppIcon.icns"

      (buildpath/"icon.r").write <<~REZ
        read 'icns' (-16455, "patinae") "AppIcon.icns";
      REZ
      system "Rez", "-i", libexec, "-o", libexec/"bin/patinae", buildpath/"icon.r"
      system "SetFile", "-a", "C", libexec/"bin/patinae"
    end

    (bin/"patinae").write <<~SH
      #!/bin/bash
      export PATINAE_PLUGIN_DIR="#{libexec}/plugins"
      export VIRTUAL_ENV="${VIRTUAL_ENV:-#{libexec}/venv}"
      exec "#{libexec}/bin/patinae" "$@"
    SH
  end

  test do
    assert_path_exists libexec/"bin/patinae"
    assert_path_exists libexec/"plugins/libraytracer_plugin.dylib"
    assert_path_exists libexec/"plugins/libpython_plugin.dylib"
    assert_match "Mach-O", shell_output("file -b #{libexec}/bin/patinae")

    # The embedded interpreter links python@3.13 and must import `patinae`.
    assert_match "python@3.13",
      shell_output("otool -L #{libexec}/plugins/libpython_plugin.dylib")
    system libexec/"venv/bin/python", "-c", "import patinae; from patinae import cmd"
  end
end
