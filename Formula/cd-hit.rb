class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/archive/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/weizhongli/cdhit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "47631dc21a652818238471695e530caa3c949841638bbb1453907c006f4f57ee" => :catalina
    sha256 "9e7bee44f6ee0b8299b24a894322bec6e9d79b28b95bee7bd8d7e0b8d59de83a" => :x86_64_linux
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace "Makefile", "-fopenmp", "-L#{Formula["libomp"].opt_lib} -lomp" if OS.mac?
    bin.mkpath
    system "make"
    system "make", "PREFIX=#{bin}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
