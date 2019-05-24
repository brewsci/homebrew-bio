class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.42.1.tar.gz"
  sha256 "6b61591dda289ac2d8361f9c1547ffbeeba3b9fbdff877dd286bad850bbd5539"
  head "https://github.com/mothur/mothur.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b1098f9c6dce8417abb486f42c3f2297b6cd593de6c9418a98b7e28b2fcedde0" => :sierra
    sha256 "78bda9eb10493199353e47a862685148632488885621de987a355b767935511d" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

  def install
    # Reduce memory usage for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    boost = Formula["boost"]
    system "make", "USEBOOST=yes", "BOOST_LIBRARY_DIR=#{boost.opt_lib}", "BOOST_INCLUDE_DIR=#{boost.opt_include}"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
