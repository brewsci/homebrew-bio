class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.400-prod-src.tar.gz"
  sha256 "2bcb9d7495048546c0159282d4edd6f95b56cdf310d661078b0853157bd24978"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "083bd8e36f0eaf48a61ee6e30e6dd4152be3999cd9833ff4ef7d6b80251d0ad5"
    sha256 arm64_sequoia: "740d18cd3da8edb011ff11ba9c9ff6a9f4d1ff600f9b520164b70007b4a7b4a2"
    sha256 arm64_sonoma:  "c443ad29ae7e0720ff4ca2d7e9dbe5dfe7868e64b2188f72cbe9356c5221631c"
    sha256 x86_64_linux:  "49ad80f097c1e84006aa028d1ae79de91e88a7dadf78cc44a9e07b14be50bb73"
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
      url "https://files.rcsb.org/download/3qug.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end
    resource("homebrew-testdata").stage testpath
    system bin/"maxit", "-input", "3qug.pdb", "-output", "3qug.cif", "-o", "1", "-log", "maxit.log"
    assert_match "_audit_author.name", File.read("3qug.cif")
  end
end
