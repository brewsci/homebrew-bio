class Bandage < Formula
  # cite Wick_2015: "https://doi.org/10.1093/bioinformatics/btv383"
  desc "Bioinf App for Navigating De novo Assembly Graphs Easily"
  homepage "https://rrwick.github.io/Bandage/"
  url "https://github.com/rrwick/Bandage/releases/download/v0.9.0/Bandage_Ubuntu-x86-64_v0.9.0_AppDir.zip"
  version "0.9.0"
  sha256 "0364ecec8dff520197e4bb10678ebbfebd83c7a1d0ed4976c7415a4bc8453527"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f9db41fa2cc366255bc4cf5d58db949f0765db087021adf6d701a44b4a2f6ab"
  end

  depends_on "patchelf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on :linux
  depends_on "mesa"

  uses_from_macos "zlib"

  def install
    prefix.install "Bandage_Ubuntu-x86-64_v#{version}/usr"
    bin.install_symlink prefix/"usr/bin/bandage"
    pkgshare.install "sample_LastGraph"
    system "patchelf",
      "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
      "--set-rpath", "$ORIGIN/../lib:#{HOMEBREW_PREFIX}/lib",
      bin/"bandage"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/bandage --help")
  end
end
