class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/2.7.2b.tar.gz"
  version "2.7.2b"
  sha256 "68222a609e13a15f214b40a882241d074163a084d9f4987743f04d853c7c8191"
  head "https://github.com/alexdobin/STAR.git"

  fails_with :clang # needs openmp

  depends_on "gcc" => :build if OS.mac? # for openmp, linked statically

  uses_from_macos "zlib"

  def install
    cd "source" do
      if OS.mac?
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
