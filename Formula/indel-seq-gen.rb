class IndelSeqGen < Formula
  # cite Strope_2009: "https://doi.org/10.1093/molbev/msp174"
  desc "Sequence simulation for divergent DNA and AA families"
  homepage "http://bioinfolab.unl.edu/~cstrope/iSG/"
  url "http://bioinfolab.unl.edu/~cstrope/iSG/indel-seq-gen-2.1.03.tar.gz"
  sha256 "4e9cf9d81eed573281fc69303fc35fe335c931496e7a403a7ea88d9b74c05d6f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9d08dd183ed7b2ddaa5e7d0e2736fd3c3a54757b8ed44276c088d98086e6d6b1" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix error: random.cpp:148:5: error: reference to 'next' is ambiguous
  depends_on :linux

  def install
    # unknown symbol getpid()
    inreplace "src/main.cpp", "<stdio.h>", "<unistd.h>"
    # exit(EXIT_FAILURE) not declared
    inreplace "src/trace.h", "<sstream>", "<sstream>\n#include <unistd.h>"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # remove Mac fork files...
    rm Dir["data/._*"]
    pkgshare.install "data"
    doc.install "doc/iSGv2_manual.pdf"
  end

  test do
    assert_match "heterogeneity", shell_output("#{bin}/indel-seq-gen -h 2>&1")
  end
end
