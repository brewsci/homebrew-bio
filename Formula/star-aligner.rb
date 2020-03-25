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
    sha256 "6f38f571a24b2fa0baec2674da051d51dd74c84823c9ef1e3537a15565d21559" => :mojave
    sha256 "17ebb8d1e4f79aad4158bb61573c6522c2a2407fccd2bae43d1d8044cd651981" => :x86_64_linux
  end

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  depends_on "gcc" => :build if OS.mac? # needs openmp, linked statically

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
