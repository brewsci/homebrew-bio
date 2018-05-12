class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  url "https://github.com/refresh-bio/KMC/archive/v3.1.0.tar.gz"
  sha256 "b931f3cc4f315c12e296fa2453c3097094ea37f2aa089a611dee15123753a81b"
  head "https://github.com/marekkokot/KMC.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "37113f2f997dafce42289bb75710a340d0623b3b77e020235ca27c349199a343" => :sierra_or_later
    sha256 "afd0759beef802e266f150b2f505445b6962c9a7d25493d4cd02a90319ff8e46" => :x86_64_linux
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
