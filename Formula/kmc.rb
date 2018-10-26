class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  url "https://github.com/refresh-bio/KMC/archive/v3.1.0.tar.gz"
  sha256 "b931f3cc4f315c12e296fa2453c3097094ea37f2aa089a611dee15123753a81b"
  head "https://github.com/marekkokot/KMC.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "01ceaecc1f729be665192020a480d5cc92d929f358a748e6ebc121c6f73ebbde" => :sierra
    sha256 "21482251545f007d0a94d03be049ce9ee31d8ff0c374782b6e647fec24c30c07" => :x86_64_linux
  end

  # Fix error: 'ext/algorithm' file not found
  fails_with :clang

  needs :cxx14

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "make", "CC=#{ENV.cxx}", "KMC_BIN_DIR=#{bin}",
      OS.mac? ? "-fmakefile_mac" : "-fmakefile"

    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kmc --version 2>&1")
    # https://github.com/refresh-bio/KMC/issues/64
    assert_match version.to_s, shell_output("#{bin}/kmc_dump --version 2>&1", 1)
    # https://github.com/refresh-bio/KMC/issues/63
    assert_match version.to_s, shell_output("#{bin}/kmc_tools 2>&1", 1)
  end
end
