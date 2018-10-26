class Ema < Formula
  # cite Shajii_2017: "https://doi.org/10.1101/220236"
  desc "Fast and accurate alignment of linked reads"
  homepage "http://ema.csail.mit.edu"
  url "https://github.com/arshajii/ema.git",
    :tag => "v0.6.2", :revision => "893be3470e613043bf75fefdc73396d40c3bc2bc"
  head "https://github.com/arshajii/ema.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "146c172575768d79936b1475d4a596d2599d8483b0e8ebd24b8808b227c4480c" => :sierra
    sha256 "9aef677e79f0853fd815c2551bedc7c0fdaae6854b6453fe12c6844812edbb60" => :x86_64_linux
  end

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
