class Patinae < Formula
  include Language::Python::Virtualenv

  desc "Fast, programmable molecular viewer for research, scripting, and the web"
  homepage "https://github.com/zmactep/patinae"
  url "https://github.com/zmactep/patinae/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "42c023a4428dfab8d0b3f8c1cd046954f25ec75bcbfd7596655621b63f78e094"
  license "BSD-3-Clause"
  head "https://github.com/zmactep/patinae.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    manifest_sha256 "a0f54a3f97b4abeb431ce4f5e9ae362536ebe123df2fe28fd03b03b43ddbdf2e"
    sha256 cellar: :any, arm64_golden_gate: "2a3ea7b417ef64a17f541aeb3e964c276f83c900719b42ad710dc2475ae36457"
    sha256 cellar: :any, arm64_tahoe:       "1e7974462fea43a35b5e3bc01fda4838d6ae4f8781890e24c8c733e836023f60"
    sha256 cellar: :any, arm64_sequoia:     "f9f7ecfc7e6f3d35cab19405e9018cc8ddeaa895c9bd412f80a48e662dd4f218"
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
