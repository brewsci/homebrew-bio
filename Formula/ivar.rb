class Ivar < Formula
  # cite Grubaugh_2019: "https://doi.org/10.1101/383513"
  desc "Viral amplicon-based sequencing pipeline"
  homepage "https://github.com/andersen-lab/ivar"
  url "https://github.com/andersen-lab/ivar/archive/v1.2.3.tar.gz"
  sha256 "58d412e9b43bee9bf7685de9df098228cbb779fadae6bea63548aaaf2eea5a3f"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ac28808f052954afd38d7a9458fb04691f9dd21ed7f157e600efdab5eb8b1326" => :catalina
    sha256 "913b6ba7011e59d2f2708021b731c986fe499bc3647c3da0c0e7c9ceecc6b2d9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "htslib"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ivar version 2>&1")
  end
end
