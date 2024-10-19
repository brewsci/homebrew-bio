class ClustalOmega < Formula
  # cite Sievers_2011: "https://doi.org/10.1038/msb.2011.75"
  desc "Fast, scalable generation multiple sequence alignments"
  homepage "http://www.clustal.org/omega/"
  url "http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz"
  sha256 "8683d2286d663a46412c12a0c789e755e7fd77088fb3bc0342bb71667f05a3ee"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "2bbd881809ee624a7b3c5732e5f37b51a2bd4df4c05b7122fb1e88cfd473a021"
    sha256 cellar: :any,                 arm64_sonoma:  "aba1fc89a09a5c52025542f9a7d15a735c97b9e4739c7770fc2aa7368e446a10"
    sha256 cellar: :any,                 ventura:       "3d35823db663fc55de82e6a30bd70a149aa35028d71a6ace84363757a3bf2564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15545ef6477891e944add3ab66efddd3cc26a682797afb4b3524321c1ebee4e0"
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
