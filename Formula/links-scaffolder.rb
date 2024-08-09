class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS.git",
      tag:      "v2.0.1",
      revision: "fc9229fb78f378b7bbf04e371da818eb418e7435"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/LINKS.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "eecf3bfbb2f0e0d32f49253946c79c13b991b58b6700caef0254c1e6551ee576"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3330b665b5bd31d7c86bde867f73b6b557ed3dc6756763492469135e4d264214"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "perl"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    inreplace "bin/LINKS.pl", "/usr/bin/env perl", Formula["perl"].bin/"perl"
    system "make", "install"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/LINKS", 1)
    assert_match "Usage:", shell_output("#{bin}/LINKS-make")
    assert_match "Usage:", shell_output("#{bin}/LINKS_CPP", 255)
    assert_match "Usage:", shell_output("#{bin}/LINKS.pl", 255)
  end
end
