class Fwdpp < Formula
  # cite "https://doi.org/10.1534/genetics.114.165019"
  desc "C++ template library for forward-time population genetic simulations"
  homepage "https://molpopgen.github.io/fwdpp/"
  url "https://github.com/molpopgen/fwdpp/archive/0.5.7.tar.gz"
  sha256 "e038462b0522f4b5aa135211222ce354df4c81a89122240b9eaacc72b62a0ceb"
  revision 2
  head "https://github.com/molpopgen/fwdpp.git"

  # build fails on Yosemite
  depends_on :macos => :el_capitan

  depends_on "boost"
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
