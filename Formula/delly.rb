class Delly < Formula
  # cite Rausch_2012: "https://doi.org/10.1093/bioinformatics/bts378"
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "914a29c301556746031586c5880e70ad7f31bd7899cc4e47b23ee4d5426761ae"
  license "BSD-3-Clause"
  head "https://github.com/tobiasrausch/delly.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "25df4a56b84b929be857de4b4c92931499b19e75a188ca45c2e6e75a15a99d39"
    sha256 cellar: :any,                 arm64_sonoma:  "3a4487022c7983800754136165f8c1fc20314202d339f725d42b96c0ee286240"
    sha256 cellar: :any,                 ventura:       "eaa7df2f3eb24c0ffc9f53d1a7994e6b8596553bc53e136b670aa66b1cc8aa9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89fdeacf3657fc08dc80f02aa7bd4b49e97d572157aed5bb4b11c6339b4fdc9e"
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
    assert_path_exists testpath/"sr.bcf"
  end
end
