class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/releases/download/V4.6.8/cd-hit-v4.6.8-2017-0621-source.tar.gz"
  version "4.6.8"
  sha256 "b67ef2b3a9ff0ee6c27b1ce33617e1bfc7981c1034ea53f8923d025144e595ac"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3db52e92cfa868b972c384b7113bfa19fdd04ce7a4206a027f7f6142dd4ee70b" => :sierra
    sha256 "415bb54b663fb976b36eb703942b8f5a392cdfd76baf08462699c5052bd9590b" => :x86_64_linux
  end

  fails_with :clang # fatal error: 'omp.h' file not found

  depends_on "gcc" if OS.mac? # needs OpenMP

  def install
    bin.mkpath
    system "make"
    system "make", "PREFIX=#{bin}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
