class Squeakr < Formula
  # cite Pandey_2017: "https://doi.org/10.1093/bioinformatics/btx636"
  desc "Exact and Approximate k-mer Counting System"
  homepage "https://github.com/splatlab/squeakr"
  url "https://github.com/splatlab/squeakr/archive/V0.7.tar.gz"
  sha256 "61f0493e5d27a7d629a87841052d174491018bb81e1876879f402d3b6885a9ff"
  license "BSD-3-Clause"
  head "https://github.com/splatlab/squeakr.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "50a1277a1a0d1d4be482856f598bc35ca24105cd698ef7d0cab9b6633a6ac461" => :x86_64_linux
  end

  depends_on "boost"
  depends_on :linux # https://github.com/splatlab/squeakr/issues/41
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
