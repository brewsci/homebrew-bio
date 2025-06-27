class Kalign < Formula
  # cite Lassmann_2019: "https://doi.org/10.1093/bioinformatics/btz795"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.1.tar.gz"
  sha256 "7f10acf9a3fa15deabbc0304e7c14efa25cea39108318c9f02b47257de2d7390"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "176d55fb00ad9c6497048b311525948747f475ed1a20ec14b82c465061deeaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0296db9227e230d5e65e5f3d044fec6dfcac288a8f10fc29a18dd3a1f4b68245"
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
