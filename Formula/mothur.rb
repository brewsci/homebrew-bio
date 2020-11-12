class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.44.3.tar.gz"
  sha256 "a9825ccbb7f60b527f63c16e07f9dd45373bdc8ee65c8f2f0b45f8b2113b2e6f"
  license "GPL-3.0"
  head "https://github.com/mothur/mothur.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "c620df4847160e97694e4871c6b7b856262e07f72a1f36a78ef39cd2c1dc2032" => :catalina
    sha256 "890a3599359b95cebf84704a746e57c14cad3a3bedd682f7fc6d013034b00497" => :x86_64_linux
  end

  depends_on "boost"

  on_linux do
    depends_on "readline"
  end

  def install
    boost = Formula["boost"]
    system "make", "USEBOOST=yes", "BOOST_LIBRARY_DIR=#{boost.opt_lib}", "BOOST_INCLUDE_DIR=#{boost.opt_include}"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
