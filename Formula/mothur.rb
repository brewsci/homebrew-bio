class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.44.2.tar.gz"
  sha256 "a79f55655a9519b357aa764972df8c5f183063ca8e278b46a204f5a2703e3d45"
  license "GPL-3.0"
  head "https://github.com/mothur/mothur.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0a406594b1f9a67f3dad8c77653547e1a68e561d9802ccc67f42b312965743d8" => :sierra
    sha256 "7544e56fb0feb4318191f92119d14bf67fd80db11203f9c9dae9bbb2b131243d" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

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
