class Kalign < Formula
  # cite Lassmann_2019: "https://doi.org/10.1093/bioinformatics/btz795"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.1.tar.gz"
  sha256 "7f10acf9a3fa15deabbc0304e7c14efa25cea39108318c9f02b47257de2d7390"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "6851604ef61179f22485d7a230de5eaf4025b4b85756d948c10ff96a61a33f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "30dc86c27dc8bf5281e9a156aab83931c8401f859a1a4bae10ebd24d066ce67c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalign -V 2>&1")
  end
end
