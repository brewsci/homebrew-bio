class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/archive/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  head "https://github.com/weizhongli/cdhit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9a3289933ffe405f4dcc43b57d582ac3757aed01901669b80c686be431a12c7f" => :sierra
    sha256 "0986ecff059b6e8bb299846a7d5257a6df127c601299e9f0afddfa0c3ec36d0b" => :x86_64_linux
  end

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  on_macos do
    depends_on "gcc" # needs openmp
  end

  def install
    bin.mkpath
    system "make"
    system "make", "PREFIX=#{bin}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
