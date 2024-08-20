class ClustalOmega < Formula
  # cite Sievers_2011: "https://doi.org/10.1038/msb.2011.75"
  desc "Fast, scalable generation multiple sequence alignments"
  homepage "http://www.clustal.org/omega/"
  url "http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz"
  sha256 "8683d2286d663a46412c12a0c789e755e7fd77088fb3bc0342bb71667f05a3ee"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "d46f7c88cc991b00f6ae70a4a3f5d0a8df72af463933cbca67061440d3be2345"
    sha256 cellar: :any,                 ventura:      "3d35823db663fc55de82e6a30bd70a149aa35028d71a6ace84363757a3bf2564"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a59a6ab424fe245c3e19e4f128ec31d6a6a5130770ddc13236e0812a306dadf"
  end

  depends_on "argtable"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clustalo --version")
  end
end
