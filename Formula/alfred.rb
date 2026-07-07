class Alfred < Formula
  # cite Rausch_2019: "https://doi.org/10.1093/bioinformatics/bty1007"
  desc "BAM Statistics, Feature Counting and Annotation"
  homepage "https://www.gear-genomics.com/alfred/"
  url "https://github.com/tobiasrausch/alfred/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "b6c9a31cfe4fd322b7bf1b09cc930ab2cd9e42efc834b0cbd6ff1ecf4307cdd9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "03b6616e65c3666f6c960b70968018a4d7128a1284358c5d2b8aeea6793a6497"
    sha256 cellar: :any, arm64_sequoia: "e2336ab1735e1d65beabea3cad3a6393508eb20c809ea31f6c7e5dc40522ef08"
    sha256 cellar: :any, arm64_sonoma:  "5343015f4f1a3147ca3c14f0b5ccbeb7579efbf2ec0b783dfbb40773b8bb7fa0"
    sha256 cellar: :any, x86_64_linux:  "fdb59cd845de1911abe7d90ce830a22081de6ed09e37fa671bd468929f41f6c3"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "xz"
  depends_on "zlib-ng-compat"

  uses_from_macos "bzip2"

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
    assert_path_exists testpath/"ecoli.json.gz"
  end
end
