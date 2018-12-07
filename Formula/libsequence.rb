class Libsequence < Formula
  # cite Thornton_2003: "https://doi.org/10.1093/bioinformatics/btg316"
  desc "C++ library for evolutionary genetics"
  homepage "https://molpopgen.github.io/libsequence/"
  url "https://github.com/molpopgen/libsequence/archive/1.9.6.tar.gz"
  sha256 "e83c4cd6924da19c22d4638a1a75fe2d11b01b66f3c68f451e93dfc697a5ef76"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "008f6df3aab70d8ce22ff09a3d32ec8f516a209860288967736af1672d70283e" => :sierra
    sha256 "67a4094bd6e38d335b0100d634539f5bfbdb9814075ef651ea7a2e6559d968fd" => :x86_64_linux
  end

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
