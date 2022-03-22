class Maxit < Formula
  desc "Assists in the processing and curation of macromolecular structure data"
  homepage "https://sw-tools.rcsb.org/apps/MAXIT"
  url "https://sw-tools.rcsb.org/apps/MAXIT/maxit-v11.100-prod-src.tar.gz"
  sha256 "373540082e02203e6b6ba43190d393da854641521d9b3843157f785273001523"
  license :cannot_represent
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 catalina:     "6efdbb45e6a34ff8e9efb7a930fedf69a1e7afd86acd60744269cc9f6346c548"
    sha256 x86_64_linux: "4c1fdb7e5d113bb4a36b95bb894bab33d9bacdc4b6320ec358846e52bca38590"
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
    inreplace "Makefile", "@sh -c './binary.csh'", "@tcsh binary.csh" if OS.linux?

    system "make", "binary"
    # install bin and data directories
    bin.install "bin/maxit", "bin/process_entry"
    prefix.install "data"
    (prefix/"data/binary/").install "variant.odb"
    (prefix/"data/binary/").install "component.odb"
  end

  test do
    assert_match "Translate PDB format", shell_output("#{bin}/maxit", 1)
  end
end
