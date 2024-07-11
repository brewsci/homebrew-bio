class Exonerate < Formula
  # cite Slater_2005: "https://doi.org/10.1186/1471-2105-6-31"
  desc "Pairwise sequence alignment of DNA and proteins"
  homepage "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
  url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.4.0.tar.gz"
  sha256 "f849261dc7c97ef1f15f222e955b0d3daf994ec13c9db7766f1ac7e77baa4042"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "fcadadfecae574f5d9aee1b1adad4a23bd24f682bc6f76358a27512025207325"
    sha256 cellar: :any, x86_64_linux: "ab0093c6b90759419d20b4905100517df0eb4b8f79ec9ef68671f6aa4473a5fc"
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
