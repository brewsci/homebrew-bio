class Biointerchange < Formula
  desc "Genomic linked-data converter: an interchange GFF, GVF, VCF files via JSON-LD"
  homepage "https://github.com/BioInterchange/BioInterchangeC"
  url "http://indie.kim/assets/biointerchange/biointerchange-2.0.5.tar.gz"
  sha256 "36fcd19b39063fab87fb9f24a0752769ada91e81b82eb354ceb65d5147128141"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "d0613db1933c9336345d411442ec8422c42101d747122f6f01ff0598e07c2281"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4457fbc917fbec9f798c18225d2d8c2daee4d8daab0000d0f44efa823887ac4"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1" => :build # linked statically
  depends_on "python@3.9"

  uses_from_macos "curl" => :build # linked statically

  on_macos do
    depends_on "gettext" => :build # linked statically
    depends_on "libiconv" => :build # linked statically
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
