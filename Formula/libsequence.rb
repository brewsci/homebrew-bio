class Libsequence < Formula
  # cite Thornton_2003: "https://doi.org/10.1093/bioinformatics/btg316"
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  url "https://github.com/molpopgen/libsequence/archive/1.9.7.tar.gz"
  sha256 "232d69fb2b6714a01c64df76fb2dc2fba072b4f7bca828ea72e2aaaa3de4585c"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c53f302106ccc56edf1fb006b16865ad1a8830babae3ec2994711a6eaa2ad0a2" => :sierra
    sha256 "914657f11e0f86f552d181a17737c3ef2dfbc1f0b7bc427ef3ec6ec65dccedfa" => :x86_64_linux
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
