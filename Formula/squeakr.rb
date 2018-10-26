class Squeakr < Formula
  # cite Pandey_2017: "https://doi.org/10.1093/bioinformatics/btx636"
  desc "Exact and Approximate k-mer Counting System"
  homepage "https://github.com/splatlab/squeakr"
  url "https://github.com/splatlab/squeakr/archive/v0.5.tar.gz"
  sha256 "9931d35e71bca0b4f0e9d3865a7c3563b2d4e7bfa03871d113777188f9b75bab"
  revision 1
  head "https://github.com/splatlab/squeakr.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6647d50895fcb8fe83e5ad85e3c02c258ca51febcdecaea3aca36e05869bb437" => :sierra
    sha256 "71962bb43d00f84054488c34c16899293f13bc4f3b0653baf89c1f9267bd59af" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "openssl"
  depends_on "bzip2" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    inreplace "Makefile", "-lboost_system -lboost_thread",
                          "-lboost_system-mt -lboost_thread-mt"
    ENV.cxx11
    # disable SSE4.2 Haswell support
    system "make", "NH=1"
    bin.install Dir["squeakr-*"]
    pkgshare.install "test.fastq"
  end

  test do
    assert_match "slots", shell_output("#{bin}/squeakr-count -h 2>&1")
    ln_s pkgshare/"test.fastq", testpath/"test.fq"
    assert_match "28206", shell_output("#{bin}/squeakr-count 0 20 1 #{testpath}/test.fq")
  end
end
