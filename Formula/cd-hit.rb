class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/archive/refs/tags/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/weizhongli/cdhit.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "8a044d33938f14d7c9160ed65a161289b3673a66631b9dd36e778c7e42867a31"
    sha256 cellar: :any,                 ventura:      "d94fa0f1f70421bd5e1e7088bde1621cf51ce050a29065ac13e66b63ccbb6f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1fc9c35d1302967c4b5c61bf99260f6aed1087770d6044f309e93dd990bfbab4"
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
