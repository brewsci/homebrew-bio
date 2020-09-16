class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/2.7.5c.tar.gz"
  version "2.7.5c"
  sha256 "980285422ea0a1c8d3b244a141a60368e6b69ba3c2b6e7cb81c52922c124dfd2"
  license "MIT"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d4a0361a3d5cc993b0fe1944ace244108be668cb32640e04ac1606c1bbec97fe" => :catalina
    sha256 "570c4c40b3b9068af98763e6f1bc1c9da3ea77a0787caf005cb29a8b14b0a34c" => :x86_64_linux
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
