class Alfred < Formula
  # cite Rausch_2019: "https://doi.org/10.1093/bioinformatics/bty1007"
  desc "BAM Statistics, Feature Counting and Annotation"
  homepage "https://www.gear-genomics.com/alfred/"
  url "https://github.com/tobiasrausch/alfred/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "506967a9588ee51911fb4ddd6d2d3274bff0140004b2473de32728de76567d05"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "68324569aa25f74056e8c0878297df0691cb8da3e2c9464e5c47992e57979e82"
    sha256 cellar: :any,                 arm64_sonoma:  "fff7de0af0d736a574ebb68c8f4d4f8bb9aa8073b94a7ebe2259a88c58feb9d1"
    sha256 cellar: :any,                 ventura:       "ef2c2d71c60ab217c38f2252cd9ae2c355a0c88c5c7bb62621ea0ccac76ff532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfcec5082dd0f4eb3ab40630d89ff4136b4529099c6a3c6ce53df139bc71e30"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "all"
    system "make", "install", "prefix=#{prefix}"
    prefix.install %w[example maps scripts gtf motif]
  end

  test do
    system "#{bin}/alfred", "--version"
    cp_r prefix/"example", testpath
    system "#{bin}/alfred", "qc", "-r", testpath/"example/E.coli.fa.gz",
                                  "-j", testpath/"ecoli.json.gz",
                                  testpath/"example/E.coli.cram"
    assert_predicate testpath/"ecoli.json.gz", :exist?
  end
end
