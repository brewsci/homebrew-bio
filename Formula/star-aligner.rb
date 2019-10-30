class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/2.7.3a.tar.gz"
  version "2.7.3a"
  sha256 "de204175351dc5f5ecc40cf458f224617654bdb8e00df55f0bb03a5727bf26f9"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5b566d7848575a257cd3ec2e8b103a5f203293c4526ff6ebfb2f834672eb98a8" => :sierra
    sha256 "63663438843f13a2cc068c727043555b2473a37e168a288117e723699d6d6a8d" => :x86_64_linux
  end

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
