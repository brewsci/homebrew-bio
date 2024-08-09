class LinksScaffolder < Formula
  # cite Warren_2015: "https://doi.org/10.1186/s13742-015-0076-3"
  desc "Long Interval Nucleotide K-mer Scaffolder"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/links"
  url "https://github.com/bcgsc/LINKS.git",
      tag:      "v2.0.1",
      revision: "fc9229fb78f378b7bbf04e371da818eb418e7435"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/LINKS.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "2a97497fdc738d9c073bb93e116a883a049b11a8bda0fcedf11835341416685b"
    sha256 cellar: :any_skip_relocation, ventura:      "7eb209d04413671e88dd04fe7aa163467e90083d805b5d806ff81397bbf1854f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f37957f2670173d5c4b9201d23590c9516d09356e24f4a1e1661de10f1ebabf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "perl"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    inreplace "bin/LINKS.pl", "/usr/bin/env perl", Formula["perl"].bin/"perl" if OS.linux?
    system "make", "install"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/LINKS", 1)
    assert_match "Usage:", shell_output("#{bin}/LINKS-make")
    assert_match "Usage:", shell_output("#{bin}/LINKS_CPP", 255)
    assert_match "Usage:", shell_output("#{bin}/LINKS.pl", 255)
  end
end
