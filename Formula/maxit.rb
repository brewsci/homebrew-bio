class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.200-prod-src.tar.gz"
  sha256 "658e236c6310cf7e55218a0500f82050ef86074f5d5b3f61d2a161b04a38cc39"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_sequoia: "14e0f9c4616a6e638516ef4beed6d453d4d6abfa95ba71b69e2d96a5c45f0d8e"
    sha256 arm64_sonoma:  "f0207bcf2353bf20f5a57b425750740ce883443301c91c26054edad9a15c8148"
    sha256 ventura:       "ac9c50b751b7255cd3a16db291d812497f31453e9d18e32eca8ae86beca0efe7"
    sha256 x86_64_linux:  "3ac605fd8c6a64cd815771e08b3d5d0ecccf58ac3174940211c12421de7d905e"
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
