class Exonerate < Formula
  # cite Slater_2005: "https://doi.org/10.1186/1471-2105-6-31"
  desc "Pairwise sequence alignment of DNA and proteins"
  homepage "https://github.com/nathanweeks/exonerate"
  url "https://github.com/nathanweeks/exonerate/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0dc29fc6fd19db2d74841c1aa4a347b7ba4d3f94ea990b6292e40d7eb2bfe958"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f9ac307541786c4b560f89db17628f83241f3b363c0ba9bae3fc0870378e8c66"
    sha256 cellar: :any,                 arm64_sequoia: "636877fce17d7ed31a5ce4b12dc9b2e9bb1aa1da4686c59f677a0bdde1d68abf"
    sha256 cellar: :any,                 arm64_sonoma:  "4247661d69f3cf87697fcb381c25a7ec43b1d4472036b46b4d3128e1004aa134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad1a359a646f3c06fe48963d4a2c69a490547fa9856a38193d2df4eaec4844a"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-glib2",
      "--prefix=#{prefix}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Examples", shell_output("#{bin}/exonerate --help", 1)
  end
end
