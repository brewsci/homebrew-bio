class Patinae < Formula
  include Language::Python::Virtualenv

  desc "Fast, programmable molecular viewer for research, scripting, and the web"
  homepage "https://github.com/zmactep/patinae"
  url "https://github.com/zmactep/patinae/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "ee91dd404550927d0d2222b0bb1c6779f3e2bbd3b37961498ad2a517c72bc21a"
  license "BSD-3-Clause"
  head "https://github.com/zmactep/patinae.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "185951219900d05cae07462d38a42f59de76c4193e092476b4fa9331bb6c3c5e"
    sha256 cellar: :any, arm64_sequoia: "2e5e327ed0873bcc56717f8779b7b5d72a70a425a02c7b7122fcf7e4ce4d8225"
  end

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on :macos
  depends_on "python@3.14"

  def install
    python = formula_opt_bin("python@3.14")/"python3.14"
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

    # The embedded interpreter links python@3.14 and must import `patinae`.
    assert_match "python@3.14",
      shell_output("otool -L #{libexec}/plugins/libpython_plugin.dylib")
    system libexec/"venv/bin/python", "-c", "import patinae; from patinae import cmd"
  end
end
