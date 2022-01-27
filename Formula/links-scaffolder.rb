class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS/releases/download/v2.0.1/links-v2.0.1.tar.gz"
  sha256 "f6f664b854b9dcc51a399af8d5ce2634f788ccdbc35e7d2732c927ca50bc7f70"
  license "GPL-3.0"

  head do
    url "https://github.com/bcgsc/LINKS.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/LINKS", 1)
    assert_match "Usage:", shell_output("#{bin}/LINKS-make")
    assert_match "Usage:", shell_output("#{bin}/LINKS_CPP", 255)
    assert_match "Usage:", shell_output("#{bin}/LINKS.pl", 255)
  end
end
