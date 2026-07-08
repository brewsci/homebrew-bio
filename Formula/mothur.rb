class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://mothur.org/"
  url "https://github.com/mothur/mothur/archive/refs/tags/v1.48.5.tar.gz"
  sha256 "d6bbd172cefdfe468d654532e620831e5e9a6814c751361034027aeb1cbccd27"
  license "GPL-3.0"
  head "https://github.com/mothur/mothur.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "c620df4847160e97694e4871c6b7b856262e07f72a1f36a78ef39cd2c1dc2032"
    sha256 cellar: :any, x86_64_linux: "890a3599359b95cebf84704a746e57c14cad3a3bedd682f7fc6d013034b00497"
  end

  depends_on "boost"

  on_linux do
    depends_on "readline"
  end

  def install
    boost = Formula["boost"]
    # On Linux the Makefile's subdir-include computation omits source/ itself,
    # so headers such as mothurout.h are not found. Add -Isource explicitly.
    inreplace "Makefile", "CXXFLAGS += -I. $(subDirIncludes)",
                          "CXXFLAGS += -I. -Isource $(subDirIncludes)"
    system "make", "USEBOOST=yes", "BOOST_LIBRARY_DIR=#{boost.opt_lib}", "BOOST_INCLUDE_DIR=#{boost.opt_include}"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
