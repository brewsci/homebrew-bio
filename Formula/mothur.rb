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
    sha256 cellar: :any, arm64_tahoe:   "bcfbcb706621e745061a2165f4ac380148f78d5f6a349e3a04e6b428301d9f10"
    sha256 cellar: :any, arm64_sequoia: "1f90df7efcdb572b0b458a9c8e4b93ad0b830813d7f0d2886fedb03c4a7d5482"
    sha256 cellar: :any, arm64_sonoma:  "40b567805e99e616a08400708221a0f523b9d62192c7d8d3de438bf40b80a646"
    sha256 cellar: :any, x86_64_linux:  "ccab1b715aea7614f1f32278922dd76659861baf393a0b0420936ece716fc932"
  end

  depends_on "boost"

  on_linux do
    depends_on "readline"
  end

  def install
    boost = Formula["boost"]
    # The Makefile's "subdirs" glob only matches source/*/ subdirectories, so
    # source/ itself is dropped from both the include path and the object list.
    # That loses the top-level sources defining main (mothur.cpp), Utils and
    # MothurOut, breaking headers and the final link. Add source/ to subdirs.
    inreplace "Makefile", "$(wildcard source/*/)",
                          "$(wildcard source/ source/*/)"
    # boost_system has been header-only since Boost 1.87, so Homebrew's boost
    # no longer builds libboost_system; drop it from the link line.
    inreplace "Makefile", "-lboost_iostreams -lboost_system -lboost_filesystem -lz",
                          "-lboost_iostreams -lboost_filesystem -lz"
    system "make", "USEBOOST=yes", "BOOST_LIBRARY_DIR=#{boost.opt_lib}", "BOOST_INCLUDE_DIR=#{boost.opt_include}"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
