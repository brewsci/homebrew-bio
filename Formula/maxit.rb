class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.200-prod-src.tar.gz"
  sha256 "658e236c6310cf7e55218a0500f82050ef86074f5d5b3f61d2a161b04a38cc39"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sonoma: "968ca571fba5c26a0ce0fbd1b0cd84bdbb5cffbb19d53ff1507c96208e3deb78"
    sha256 ventura:      "77968c77f78b75212fa0ba88b757877859f5f73f4cd3fab61ac0fa60646c5256"
    sha256 x86_64_linux: "a7e35b587ca07d9d443280a74a370df109089f9301048a937f5e9efb153135ec"
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
