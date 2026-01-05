class ClustalOmega < Formula
  # cite Sievers_2011: "https://doi.org/10.1038/msb.2011.75"
  desc "Fast, scalable generation multiple sequence alignments"
  homepage "http://www.clustal.org/omega/"
  url "http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz"
  sha256 "8683d2286d663a46412c12a0c789e755e7fd77088fb3bc0342bb71667f05a3ee"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "807996c8f370bd8ef87045cf35baaf78953ae1514b0ddcf468b8401d2baca524"
    sha256 cellar: :any,                 arm64_sequoia: "fd501728fd220c1aa96a0c62ed8cbf35be06f3508ab1a43eb83cfb0eb1e3ffd0"
    sha256 cellar: :any,                 arm64_sonoma:  "8b5d20b9292e8243441cb69a89956c8789d0412e360651c24e3f6f22532cd148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4f6c9945f35c43213059aa2af5fb96c0ec04e254b75caff9bbdb5226e7d27e"
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
