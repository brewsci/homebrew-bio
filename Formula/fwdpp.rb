class Fwdpp < Formula
  # cite Thornton_2014: "https://doi.org/10.1534/genetics.114.165019"
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.8.1.tar.gz"
  sha256 "63392c05afb46161186e462c5fbbe0610d261fadcac41b17f6e037011affdbbe"
  license "GPL-3.0"
  head "https://github.com/molpopgen/fwdpp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d0014bafc11585b97e0829c64469f109000ff575a006c5dc12f2f3430e626df0" => :catalina
    sha256 "9b041f87548111fc86efceccd180c670a0b99df1055305a884e4b8fdedcadb69" => :x86_64_linux
  end

  # build fails on Yosemite
  depends_on "boost"
  depends_on "brewsci/bio/libsequence"
  depends_on "gsl"
  depends_on macos: :el_capitan

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
