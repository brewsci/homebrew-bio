class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.11b.tar.gz"
  version "2.7.11b"
  sha256 "3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7"
  license "MIT"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8a4f1c52339018e7d94366939b7a2c3506ec73c758c5676065ef4381237dc16d"
    sha256 cellar: :any_skip_relocation, ventura:      "546a1c946a8bdb4b53a7a21f63e69982bef409e9243c68dbcd9e83cd1ddd87dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "424189a12e3a925fca8f94c4e09fc127bf9835d49a29048846c03cda131cb20a"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    cd "source" do
      if OS.mac?
        inreplace "Makefile", "-static-libgcc", ""
        system "make", "STARforMacStatic", "STARlongForMacStatic"
      else
        system "make", "STAR", "STARlong"
      end
      bin.install "STAR", "STARlong"
    end
    doc.install "doc/STARmanual.pdf"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/STAR --help")
    assert_match "Usage:", shell_output("#{bin}/STARlong --help")
  end
end
