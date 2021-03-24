class Biointerchange < Formula
  desc "Genomic linked data converter. Interchange GFF, GVF, VCF files via JSON."
  homepage "https://github.com/BioInterchange/BioInterchangeC"
  url "http://indie.kim/assets/biointerchange/biointerchange-2.0.5.tar.gz"
  sha256 "16f4bb6a1b5b5d0cb361ad5ab8b2bd5c49cd79ab6d30fa0b8c2922d99cf97600"
  license "MIT"

  depends_on "autoconf" => :build
  depends_on "cmake" => :build

  def install
    # Note: Cannot parallelize, because:
    # 1. OpenSSL, curl, and LibDocument are all ExternalProjects
    # 2. LibDocument also pulls & builds CPython
    ENV.deparallelize
    system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-G", "Unix Makefiles"
    system "make", "python"
    system "make", "openssl-lib"
    system "make", "curl-lib"
    system "make", "libdocument-lib"
    system "make", "biointerchange"
    system "strip", "biointerchange"
    bin.install "biointerchange"
  end

  test do
    assert_match "2.0.5+133", shell_output("#{bin}/biointerchange -v")
    
    assert_match "       0", shell_output("#{bin}/biointerchange -v | wc -l")
    assert_match "      15", shell_output("#{bin}/biointerchange -v 3>&1 1>&2 2>&3 | wc -l")
  end
end
