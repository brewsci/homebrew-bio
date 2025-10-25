class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.400-prod-src.tar.gz"
  sha256 "2bcb9d7495048546c0159282d4edd6f95b56cdf310d661078b0853157bd24978"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "235d105449dde8db3df3d81311f4eaba17b8bac970c71d2eb00f5af0bca546dd"
    sha256 arm64_sonoma:  "4e0d922714e1720777b8dcbeba13a8b297b7544ac27869c8f9d149f6e0864bf0"
    sha256 ventura:       "c4dd7df1de917153487c30043a54681872fda42a6c03e4aefe40ed0173870eb9"
    sha256 x86_64_linux:  "697d345cf0abb3345619b0c15533e0b14289ea42d31c4b8899fec98595128f38"
  end

  def install
    ENV.deparallelize
    cd "maxit-v10.1/src" do
      inreplace ["maxit.C", "process_entry.C", "generate_assembly_cif_file.C"],
                "rcsbroot = getenv(\"RCSBROOT\")", "rcsbroot = \"#{prefix}\""
    end
    # circumvent CI errors
    inreplace "cifparse-obj-v7.0/Makefile", "mv", "cp"
    system "make", "binary"
    # install bin and data directories
    bin.install Dir["bin/*"]
    prefix.install "data"
  end

  test do
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end
    resource("homebrew-testdata").stage testpath
    system bin/"maxit", "-input", "3qug.pdb", "-output", "3qug.cif", "-o", "1", "-log", "maxit.log"
    assert_match "_audit_author.name", File.read("3qug.cif")
  end
end
