class Ema < Formula
  # cite Shajii_2017: "https://doi.org/10.1101/220236"
  desc "Fast and accurate alignment of linked reads"
  homepage "http://ema.csail.mit.edu"
  url "https://github.com/arshajii/ema.git",
    :tag => "v0.6.1", :revision => "bf4376b506a4461da03879c317d69f6b8e69e4a4"
  head "https://github.com/arshajii/ema"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "afaa81140abaf043c99a0cbf0eeea9a70d516595ed78b96f46324237cea90cb4" => :sierra_or_later
    sha256 "eda95342a40a2092b760798638fc119b0f83a643a1d87ef520ae7a04e67b91ff" => :x86_64_linux
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
