class Rmblast < Formula
  desc "RepeatMasker compatible version of the standard NCBI BLAST suite"
  homepage "http://www.repeatmasker.org/RMBlast.html"
  if OS.mac?
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-2.2.28-universal-macosx.tar.gz"
    sha256 "f94e91487b752eb24386c3571250a3394ec7a00e7a5370dd103f574c721b9c81"
  else
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/LATEST/ncbi-rmblastn-2.2.28-x64-linux.tar.gz"
    sha256 "e6503ad25a6760d2d2931f17efec80ba879877b4042a1d10a60820ec21a61cfe"
  end
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bd7e6df63714fb2cc07ea1bc5dc3fcfb23364d8f86a66fd6bf8af333d8a18dc1" => :sierra
    sha256 "e4179700df3ad81604cb6031a9d82e971d3fa88ac0c9b6d8f949af3b8be3edb8" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    prefix.install Dir["*"]
    unless OS.mac?
      system "patchelf", bin/"rmblastn",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX
    end
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rmblastn -help")
  end
end
