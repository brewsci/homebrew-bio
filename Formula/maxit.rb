class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.100-prod-src.tar.gz"
  sha256 "e5c6656ea00a6716ca4c390cbd527ebb67a4837ea81c516220853fbb15c8af1d"
  license :cannot_represent
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 x86_64_linux: "2699a66a7c31bbb86b4ce939822d2d1cec3a393b917a13f6f0956f62b62d1577"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "tcsh" => :build
  depends_on "gcc"

  fails_with gcc: "5"

  def install
    ENV.deparallelize
    # fix env variable "RCSBROOT" to HOMEBREW PREFIX
    inreplace "maxit-v10.1/src/maxit.C", "rcsbroot = getenv(\"RCSBROOT\")", "rcsbroot = \"#{prefix}\""
    inreplace "maxit-v10.1/src/process_entry.C", "rcsbroot = getenv(\"RCSBROOT\")", "rcsbroot = \"#{prefix}\""
    # some tricks to circumvent CI errors
    inreplace "cifparse-obj-v7.0/Makefile", "mv", "cp"
    inreplace "binary.csh", "./data/binary", "#{prefix}/data/binary"

    system "make", "binary"
    # install bin and data directories
    bin.install "bin/maxit", "bin/process_entry"
    prefix.install "data"
  end

  test do
    assert_match "Translate PDB format", shell_output("#{bin}/maxit", 1)
  end
end
