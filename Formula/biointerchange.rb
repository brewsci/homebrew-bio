class Biointerchange < Formula
  desc "Genomic linked-data converter: an interchange GFF, GVF, VCF files via JSON-LD"
  homepage "https://github.com/BioInterchange/BioInterchangeC"
  url "http://indie.kim/assets/biointerchange/biointerchange-2.0.5.tar.gz"
  sha256 "36fcd19b39063fab87fb9f24a0752769ada91e81b82eb354ceb65d5147128141"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "googletest" => :test
  depends_on "curl"
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  on_macos do
    depends_on "libiconv"
  end

  def install
    # NOTE: Cannot parallelize, because of ExternalProject in CMakeLists.txt
    ENV.deparallelize
    system "cmake", *std_cmake_args
    system "make", "libdocument-lib"
    system "make", "biointerchange"
    bin.install "biointerchange"
  end

  test do
    assert_match "2.0.5+139\n", shell_output("#{bin}/biointerchange -v")
  end
end
