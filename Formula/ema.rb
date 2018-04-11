class Ema < Formula
  # cite Shajii_2017: "https://doi.org/10.1101/220236"
  desc "Fast and accurate alignment of linked reads"
  homepage "http://ema.csail.mit.edu"
  url "https://github.com/arshajii/ema.git",
    :tag => "0.6.0", :revision => "4e72fe2b1a207d9d5d75ecbf0a782987b3e9f250"
  head "https://github.com/arshajii/ema"

  fails_with :clang # needs openmp
  needs :cxx14

  if OS.mac?
    depends_on "gcc" # needs openmp
  else
    depends_on "zlib"
  end

  resource "4M-with-alts" do
    url "https://raw.githubusercontent.com/10XGenomics/supernova/master/tenkit/lib/python/tenkit/barcodes/4M-with-alts-february-2016.txt"
    version "february-2016"
    sha256 "47d7109416f06a7f4c78ed4b2dcb62682b5ca60edf421c687087d8084cf5f192"
  end

  def install
    # Fix error: This file requires compiler and library support for the ISO C++ 2011 standard.
    ENV.deparallelize

    system "make"
    bin.install "ema"
    prefix.install resource("4M-with-alts")
  end

  def caveats
    "The barcode whitelist is available at\n#{prefix/"4M-with-alts-february-2016.txt"}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/ema help")
  end
end
