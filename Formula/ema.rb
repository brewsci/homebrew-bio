class Ema < Formula
  # cite Shajii_2017: "https://doi.org/10.1101/220236"
  desc "Fast and accurate alignment of linked reads"
  homepage "http://ema.csail.mit.edu"
  url "https://github.com/arshajii/ema.git",
    tag: "v0.6.2", revision: "893be3470e613043bf75fefdc73396d40c3bc2bc"
  license "MIT"
  revision 1
  head "https://github.com/arshajii/ema.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "a151d79e6e17971cb7e9e0edd480900ebeedcd5bc952d0bde24273c76a412dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6f4bfa74c1252a1f1e7b338c5ad0160bf7a384746eb9905ecb91d344b3dd483"
  end

  fails_with :clang # needs openmp

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
    # Need patch: https://github.com/lh3/bwa/issues/314
    inreplace "bwa/Makefile", "-Wno-unused-function -O2", "-Wno-unused-function -O2 -fcommon"
    inreplace "bwa/rle.h", "const uint8_t rle_auxtab[8];", "extern const uint8_t rle_auxtab[8];"

    ENV.deparallelize
    system "make"
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
