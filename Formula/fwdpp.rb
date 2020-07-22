class Fwdpp < Formula
  # cite Thornton_2014: "https://doi.org/10.1534/genetics.114.165019"
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.6.1.tar.gz"
  sha256 "aba56a6e4ddc67f55859b5446154a10fe830bfe70ad49565368eae045272e7d1"
  revision 1
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "469109b8eea18249546acedf8a9fd680489fd012a1844c9e484063736f84b83d" => :catalina
    sha256 "ffd5505630ad506d74ced9ece2ea81ee4583669ce6f32a32a190977e5b55947d" => :x86_64_linux
  end

  # build fails on Yosemite
  depends_on "boost" => :build
  depends_on "brewsci/bio/libsequence"
  depends_on "gsl"
  depends_on :macos => :el_capitan

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "testsuite/unit"
  end

  test do
    assert_equal version, shell_output("#{bin}/fwdppConfig --version")
  end
end
