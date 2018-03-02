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
