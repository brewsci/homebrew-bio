class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "http://sun.aei.polsl.pl/kmc/"
  url "https://github.com/marekkokot/KMC/archive/v3.0.1.tar.gz"
  sha256 "0dbc9254f95541a060d94076d2aa03bb57eb2da114895848f65af0db1e4f8b67"
  head "https://github.com/marekkokot/KMC.git"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3f6989a7acf4d982edd19b96360ece099f288f919c74f4dbf5cd5a59bf295fd9" => :x86_64_linux
  end

  fails_with :clang # fatal error: 123:10: 'ext/algorithm' file not found

  depends_on "gcc" if OS.mac?

  needs :cxx14

  def install
    # https://github.com/refresh-bio/KMC/issues/50
    # g++ --std=c++14 error: 'modf' is not a member of 'std'
    inreplace "kmc_api/kmer_defs.h", "<math.h>", "<cmath>"

    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "make", "CC=#{ENV.cxx}", "KMC_BIN_DIR=#{bin}",
      OS.mac? ? "-fmakefile_mac" : "-fmakefile"

    doc.install "kmc_tools.pdf"
  end

  test do
    assert_match "occurring", shell_output("#{bin}/kmc --help 2>&1")
  end
end
