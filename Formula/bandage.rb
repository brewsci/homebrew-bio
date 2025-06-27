class Bandage < Formula
  # cite Wick_2015: "https://doi.org/10.1093/bioinformatics/btv383"
  desc "Bioinf App for Navigating De novo Assembly Graphs Easily"
  homepage "https://rrwick.github.io/Bandage/"
  url "https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_dynamic_v0_8_1.zip"
  sha256 "2e8332e59b95438040a1b0ad29b3730ac63d7c638c635aeddde4789bf7a3116c"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f9db41fa2cc366255bc4cf5d58db949f0765db087021adf6d701a44b4a2f6ab"
  end

  depends_on :linux
  depends_on "qt"
  depends_on "patchelf" => :build unless OS.mac?

  uses_from_macos "zlib"

  def install
    bin.install "Bandage"
    unless OS.mac?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib:#{Formula["qt"].opt_lib}",
        bin/"Bandage"
    end
    pkgshare.install "sample_LastGraph"
    doc.install "dependencies"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/Bandage --help")
  end
end
