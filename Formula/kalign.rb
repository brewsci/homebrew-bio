class Kalign < Formula
  # cite Lassmann_2019: "https://doi.org/10.1093/bioinformatics/btz795"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.3.2.tar.gz"
  sha256 "c0b357feda32e16041cf286a4e67626a52bbf78c39e2237b485d54fb38ef319a"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "7cce83abecd04993bb30ae4b898346b6dd22efd471cd52559d34da61400e6dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "df20a7be2f77b47aa2fe2e01dbfb974cba84be92ddbc9b4ec6d18a01594d3e62"
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
