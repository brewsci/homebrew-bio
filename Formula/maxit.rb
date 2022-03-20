class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.100-prod-src.tar.gz"
  sha256 "373540082e02203e6b6ba43190d393da854641521d9b3843157f785273001523"
  license :cannot_represent

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "tcsh" => :build
  depends_on "gcc"

  fails_with gcc: "5"

  def install
    ENV.deparallelize
    # fix env variable "RCSBROOT" to HOMEBREW PREFIX
    inreplace "maxit-v10.1/src/maxit.C", "rcsbroot = getenv(\"RCSBROOT\")", "rcsbroot = \"#{bin}\""
    inreplace "maxit-v10.1/src/process_entry.C", "rcsbroot = getenv(\"RCSBROOT\")", "rcsbroot = \"#{bin}\""
    inreplace "connect-v3.3/src/connect_main.C", "root_dir = getenv(\"RCSBROOT\")", "root_dir = \"#{bin}\""
    # Do not delete TMPLIB
    inreplace "cifparse-obj-v7.0/Makefile", "mv", "cp"
    # trick to circumvent a CI error on Linux
    inreplace "Makefile", "@sh -c './binary.csh'", "@tcsh binary.csh" if OS.linux?

    system "make", "binary"
    # install bin and data directories
    bin.install "bin/maxit", "bin/process_entry"
    prefix.install "data"
  end

  test do
    assert_match "Translate PDB format", shell_output("#{bin}/maxit", 1)
  end
end
