class Libsequence < Formula
  # cite Thornton_2003: "https://doi.org/10.1093/bioinformatics/btg316"
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  url "https://github.com/molpopgen/libsequence/archive/1.9.8.tar.gz"
  sha256 "16c3ff6490861806292391195a8698fc17f4d5d30cbe3f5e5e1de1a03d1105f8"
  license "GPL-3.0"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b93b5ff4288ec661eda9b092f1a82098d3b3a55f2f4bc5f9a8e6812be1634ac9" => :catalina
    sha256 "d0771ecd4b05d341e51dfa83ceebe5999611dac1ae3a77596184ac7b4a436f76" => :x86_64_linux
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
