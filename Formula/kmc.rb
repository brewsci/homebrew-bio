class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  url "https://github.com/refresh-bio/KMC/archive/v3.1.1.tar.gz"
  sha256 "d7cdf37d90a07d1a432b7427436f962914b5f63a1b6dbb9a116609a1c64d1324"
  head "https://github.com/marekkokot/KMC.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "01ceaecc1f729be665192020a480d5cc92d929f358a748e6ebc121c6f73ebbde" => :sierra
    sha256 "21482251545f007d0a94d03be049ce9ee31d8ff0c374782b6e647fec24c30c07" => :x86_64_linux
  end

  depends_on "gcc"
  uses_from_macos "zlib"
  uses_from_macos "bzip2"

  # Fix error: 'ext/algorithm' file not found
  fails_with :clang

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    args = %W[CC=#{ENV.cxx} KMC_BIN_DIR=#{bin}]
    args << (OS.mac? ? "-fmakefile_mac" : "-fmakefile")

    system "make", *args, "kmc", "kmc_dump", "kmc_tools"

    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kmc --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_dump --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_tools 2>&1")
  end
end
