class Bandage < Formula
  # cite Wick_2015: "https://doi.org/10.1093/bioinformatics/btv383"
  desc "Bioinf App for Navigating De novo Assembly Graphs Easily"
  homepage "https://rrwick.github.io/Bandage/"
  url "https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_dynamic_v0_8_1.zip"
  sha256 "2e8332e59b95438040a1b0ad29b3730ac63d7c638c635aeddde4789bf7a3116c"

  depends_on :linux
  depends_on "qt"

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "zlib"
  end

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
    # Bandage is a GUI with no command line testing capability
  end
end
