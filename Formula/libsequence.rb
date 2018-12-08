class Libsequence < Formula
  # cite Thornton_2003: "https://doi.org/10.1093/bioinformatics/btg316"
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  url "https://github.com/molpopgen/libsequence/archive/1.9.3.tar.gz"
  sha256 "f834da85d4f5265eb8e4d34642fa4d4517d5d3694c0ae9db6e7b919fffd65eea"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b5307598ac42979585759217d4731b09b0b884bdd6c8f8aaa972b720e47be38e" => :sierra
    sha256 "28860452fe218465728bc696682b9a434e9944e83431f91469afc710cb4dc089" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "gsl"
  depends_on "tbb"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure",
      "--prefix=#{prefix}",
      "--docdir=#{doc}",
      "--mandir=#{man}",
      "--disable-dependency-tracking",
      "--disable-silent-rules"
    system "make"
    ENV.deparallelize { system "make", "check" }
    system "make", "install"
  end

  test do
    assert_equal version, shell_output("#{bin}/libsequenceConfig --version")
  end
end
