class Ivar < Formula
  # cite Grubaugh_2019: "https://doi.org/10.1101/383513"
  desc "Viral amplicon-based sequencing pipeline"
  homepage "https://github.com/andersen-lab/ivar"
  url "https://github.com/andersen-lab/ivar/archive/v1.1-beta.tar.gz"
  version "1.1" # it self reports as this
  sha256 "86438307169a7c0ff97acb06c94ca7e438f47b8bbb3b203d3499521e3d13e181"

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
