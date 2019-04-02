class Libsequence < Formula
  # cite Thornton_2003: "https://doi.org/10.1093/bioinformatics/btg316"
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  url "https://github.com/molpopgen/libsequence/archive/1.9.7.tar.gz"
  sha256 "232d69fb2b6714a01c64df76fb2dc2fba072b4f7bca828ea72e2aaaa3de4585c"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b5307598ac42979585759217d4731b09b0b884bdd6c8f8aaa972b720e47be38e" => :sierra
    sha256 "28860452fe218465728bc696682b9a434e9944e83431f91469afc710cb4dc089" => :x86_64_linux
  end

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
