class StarAligner < Formula
  # cite Dobin_2012: "https://doi.org/10.1093/bioinformatics/bts635"
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/2.7.5b.tar.gz"
  version "2.7.5b"
  sha256 "8d50ad715e1204b69ff155bb97af8358bdfb564879e23654d4edb8ec28e598d0"
  license "MIT"
  head "https://github.com/alexdobin/STAR.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f93b98624ad490ec9aa0d3e44f2323040c37e87210d7a14b29aa65f31eb4808e" => :catalina
    sha256 "53ea9c1f680542443d38d58d393b22660afec15a497ac4e78c706e380abe918d" => :x86_64_linux
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
