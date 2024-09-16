class Delly < Formula
  # cite Rausch_2012: "https://doi.org/10.1093/bioinformatics/bts378"
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "f7f67b6c01d3840376a4da89b9157cacea77eda2b078a4aa6502403b3fd8dffd"
  license "BSD-3-Clause"
  head "https://github.com/tobiasrausch/delly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "cef13a263a84ec23a8708f909345c1cdbfa000135d9c21dc0a00b45d91f1aed6"
    sha256 cellar: :any, x86_64_linux: "9453aaa771a707a430ac9f82a41ef086df4572b55244fa1a0a9d2471c6db52b5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?
    system "make", "PARALLEL=1", "src/delly"
    bin.install "src/delly"
    prefix.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system "#{bin}/delly", "call", "-g", prefix/"example/ref.fa", "-o", testpath/"sr.bcf", prefix/"example/sr.bam"
    assert_predicate testpath/"sr.bcf", :exist?
  end
end
