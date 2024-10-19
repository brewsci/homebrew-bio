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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "0b6d5057deb84b1911c092cd83ed292d1259ce0d353e833c9e39db858b2f7389"
    sha256 cellar: :any,                 arm64_sonoma:  "2b4bd6d46a3cd9c7a71d085023c2af885474e5c7a9a6624151c1ec2b7065a882"
    sha256 cellar: :any,                 ventura:       "d493887c1b34e0e8106ec6d850b055bf0a5611223f13e070ab58f1ea4e67f785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74200f596e0cf3345e5d111e3d29fb8366fe96a1e4fb52178cd072964777b46d"
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
