class Ivar < Formula
  # cite Grubaugh_2019: "https://doi.org/10.1101/383513"
  desc "Viral amplicon-based sequencing pipeline"
  homepage "https://github.com/andersen-lab/ivar"
  url "https://github.com/andersen-lab/ivar/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "e5c3905ffefb910a22aee44dc9374bf597b1cad84821c5f3b9e780d73513c083"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "7f7d05e1565b69cde419d85626487bb0775364b255f51159b5c2be127f0240c1"
    sha256 cellar: :any, x86_64_linux: "a2b146005d4a65c00ce45ea3c2a82e819d6a7a7611d2799fb43eee414af600c9"
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
