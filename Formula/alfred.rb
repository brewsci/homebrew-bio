class Alfred < Formula
  # cite Rausch_2019: "https://doi.org/10.1093/bioinformatics/bty1007"
  desc "BAM Statistics, Feature Counting and Annotation"
  homepage "https://www.gear-genomics.com/alfred/"
  url "https://github.com/tobiasrausch/alfred/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "506967a9588ee51911fb4ddd6d2d3274bff0140004b2473de32728de76567d05"
  license "BSD-3-Clause"

  depends_on "boost"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "all"
    system "make", "install", "prefix=#{prefix}"
    prefix.install %w["example" "maps" "scripts" "gtf" "motif"]
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
