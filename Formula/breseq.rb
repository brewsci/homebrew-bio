class Breseq < Formula
  # Deatherage_2014: "https://doi.org/10.1007/978-1-4939-0554-6_12"
  desc "Find mutations in microbes from short reads"
  homepage "http://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.33.0/breseq-0.33.0-Source.tar.gz"
  sha256 "f553931e810a5c31434f2f90e977589c99c9dcbd258045df9fd37acc21d58574"
  head "https://github.com/barricklab/breseq.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3b2e34a9b72e16b288ee4505c1c550a31829b4b5f4de2e7591c648b91a743db2" => :sierra
    sha256 "1dbff33c770ed9ce16a0225023af135a81d9b24d2aba322cbafb5a66cd4ba3b9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bowtie2"
  depends_on "gzip" unless OS.mac?
  depends_on "r"

  needs :cxx11

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    system "./configure", "--prefix=#{prefix}", "--without-libunwind"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/breseq --version 2>&1")
    assert_match "regardless", shell_output("#{bin}/breseq -h 2>&1", 255)
  end
end
