class ClustalOmega < Formula
  # cite Sievers_2011: "https://doi.org/10.1038/msb.2011.75"
  desc "Fast, scalable generation multiple sequence alignments"
  homepage "http://www.clustal.org/omega/"
  url "http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz"
  sha256 "8683d2286d663a46412c12a0c789e755e7fd77088fb3bc0342bb71667f05a3ee"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1f67880767ddb90a20c34dc57d1cb29c41bd712dadb07ebabedb1e72aefae3c6" => :sierra
    sha256 "e63bbab0368c0dc91debd75153396a11639716506560c61dc1251cfd7b5d39ee" => :x86_64_linux
  end

  depends_on "argtable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clustalo --version")
  end
end
