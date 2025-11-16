class Exonerate < Formula
  # cite Slater_2005: "https://doi.org/10.1186/1471-2105-6-31"
  desc "Pairwise sequence alignment of DNA and proteins"
  homepage "https://github.com/nathanweeks/exonerate"
  url "https://github.com/nathanweeks/exonerate/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0dc29fc6fd19db2d74841c1aa4a347b7ba4d3f94ea990b6292e40d7eb2bfe958"
  license "GPL-3.0-only"
  revision 1

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
