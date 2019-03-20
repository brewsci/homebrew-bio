class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/archive/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  head "https://github.com/weizhongli/cdhit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3db52e92cfa868b972c384b7113bfa19fdd04ce7a4206a027f7f6142dd4ee70b" => :sierra
    sha256 "415bb54b663fb976b36eb703942b8f5a392cdfd76baf08462699c5052bd9590b" => :x86_64_linux
  end

  fails_with :clang # fatal error: 'omp.h' file not found

  if OS.mac?
    depends_on "gcc" # needs OpenMP
  else
    depends_on "zlib"
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
