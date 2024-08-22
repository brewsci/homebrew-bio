class Ema < Formula
  # cite Shajii_2017: "https://doi.org/10.1101/220236"
  desc "Fast and accurate alignment of linked reads"
  homepage "https://ema.csail.mit.edu"
  url "https://github.com/arshajii/ema.git",
    tag: "v0.7.0", revision: "2e0d8a2a00b08c246a125566cd9ee636879cc457"
  license "MIT"
  head "https://github.com/arshajii/ema.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "a151d79e6e17971cb7e9e0edd480900ebeedcd5bc952d0bde24273c76a412dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6f4bfa74c1252a1f1e7b338c5ad0160bf7a384746eb9905ecb91d344b3dd483"
  end

  depends_on "pigz"
  depends_on "sambamba"
  depends_on "samtools"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "4M-with-alts" do
    url "https://raw.githubusercontent.com/10XGenomics/supernova/master/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt"
    version "february-2016"
    sha256 "47d7109416f06a7f4c78ed4b2dcb62682b5ca60edf421c687087d8084cf5f192"
  end

  def install
    if OS.mac?
      inreplace "Makefile" do |s|
        s.gsub! "-lm -lz -lpthread", "-lm -lz -lpthread -lomp"
        s.gsub! "CFLAGS = -std=gnu99 -march=x86-64 -O3 -fopenmp",
                "CFLAGS = -std=gnu99 -march=native -O3 -Xpreprocessor -fopenmp"
        s.gsub! "LFLAGS = -lstdc++ -march=x86-64 -O3 -flto -fopenmp",
                "LFLAGS = -lstdc++ -march=native -O3 -flto -Xpreprocessor -fopenmp"
        s.gsub! "CPPFLAGS = -c -std=c++11 -O3 -march=x86-64 -pthread",
                "CPPFLAGS = -std=c++11 -O3 -march=native -Xpreprocessor -fopenmp"
      end
    end
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "ema"
    prefix.install resource("4M-with-alts")
  end

  def caveats
    "The barcode allowlist is available at\n#{prefix/"4M-with-alts-february-2016.txt"}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/ema help")
  end
end
