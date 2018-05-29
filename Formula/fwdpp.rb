class Fwdpp < Formula
  # cite Thornton_2014: "https://doi.org/10.1534/genetics.114.165019"
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.6.1.tar.gz"
  sha256 "aba56a6e4ddc67f55859b5446154a10fe830bfe70ad49565368eae045272e7d1"
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "e24702907b9391dc74648cd0afa66bb471085b8ca7f816d76820a5d50e5069ed" => :sierra_or_later
    sha256 "f5a7a5054efbdea1096c655f4d44f265886721bee0c4e1ddf027a559a26fc26b" => :x86_64_linux
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
