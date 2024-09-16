class Alfred < Formula
  # cite Rausch_2019: "https://doi.org/10.1093/bioinformatics/bty1007"
  desc "BAM Statistics, Feature Counting and Annotation"
  homepage "https://www.gear-genomics.com/alfred/"
  url "https://github.com/tobiasrausch/alfred/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "506967a9588ee51911fb4ddd6d2d3274bff0140004b2473de32728de76567d05"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "305a6ca19f927d984c859b5c44fcb0a42a31bc2a4c8dd51020e810c0ad16e9ed"
    sha256 cellar: :any,                 ventura:      "d5d76f5d91cef89d039da625149f9905dcefe20b8b1c5ee03f719c77c2635379"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "44f2d48689532a38f791d52175cc1fdf8b07ed179c35f764e444201bd801dd9b"
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
