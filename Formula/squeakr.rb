class Squeakr < Formula
  # cite Pandey_2017: "https://doi.org/10.1093/bioinformatics/btx636"
  desc "Exact and Approximate k-mer Counting System"
  homepage "https://github.com/splatlab/squeakr"
  url "https://github.com/splatlab/squeakr/archive/V0.6.tar.gz"
  sha256 "6738efd60a32362d98be311b949012a57787d0ee77679ac1016809267b6f29b2"
  head "https://github.com/splatlab/squeakr.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "dfa98d5cd8460acb93fc203e112ca594513f45dde30761d22a816dee6fddd6a3" => :sierra
    sha256 "ca1e2c8f2c704153e82faa2cbfcbad90af363e397e22c035ce33fdb2f021a710" => :x86_64_linux
  end

  depends_on "boost"
  depends_on :linux # https://github.com/splatlab/squeakr/issues/40
  depends_on "openssl"
  depends_on "bzip2" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  def install
    inreplace "Makefile", "-lboost_system", "-lboost_system-mt"
    inreplace "Makefile", "-lboost_thread", "-lboost_thread-mt"
    ENV.cxx11
    # use "make NH=1" to disable SSE4.2 Haswell support
    system "make"
    bin.install "squeakr"
    pkgshare.install "data/test.fastq"
  end

  test do
    assert_match "inner_prod", shell_output("#{bin}/squeakr 2>&1")
    assert_match "28206", shell_output("#{bin}/squeakr count -e -k 28 -s 20 -t 1 -o /dev/null #{pkgshare}/test.fastq")
  end
end
