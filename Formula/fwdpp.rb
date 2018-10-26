class Fwdpp < Formula
  # cite Thornton_2014: "https://doi.org/10.1534/genetics.114.165019"
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.6.1.tar.gz"
  sha256 "aba56a6e4ddc67f55859b5446154a10fe830bfe70ad49565368eae045272e7d1"
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "5ac03ce334689ebd1f516eb86b3ae0fb7b8f0181ab18d2342230b77cf4693edb" => :sierra
    sha256 "b0cb4ea0d175ce870981dc7e66439fb990283eade34fd37076e119fe48c67c77" => :x86_64_linux
  end

  # build fails on Yosemite
  depends_on :macos => :el_capitan

  depends_on "boost" => :build
  depends_on "gsl"
  depends_on "libsequence"

  def install
    # Reduce memory usage for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "testsuite/unit"
  end

  test do
    assert_equal version, shell_output("#{bin}/fwdppConfig --version")
  end
end
