class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.44.2.tar.gz"
  sha256 "a79f55655a9519b357aa764972df8c5f183063ca8e278b46a204f5a2703e3d45"
  license "GPL-3.0"
  head "https://github.com/mothur/mothur.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "c0c11054955bb00d49c7b0e0d4eec7e3314cad1596e26878d6d99f39cf5b2c96" => :catalina
    sha256 "6dd047aa176b43cff1d5058bc684eb9b350bdb26e77cf75ef7d6e089a5e0f488" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

  def install
    # Fixed in https://github.com/mothur/mothur/pull/736
    inreplace "Makefile", "./make", "make"

    boost = Formula["boost"]
    system "make", "USEBOOST=yes", "BOOST_LIBRARY_DIR=#{boost.opt_lib}", "BOOST_INCLUDE_DIR=#{boost.opt_include}"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
