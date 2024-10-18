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
    sha256 cellar: :any,                 arm64_sonoma: "d33c86732db4f26512c8dd3c6349a9b886b94e3fa1a2c6dab573dab551b17107"
    sha256 cellar: :any,                 ventura:      "09422a9ca5568985086099ce7aad406c437f1fce52a7ebe5599ec05cfe6edb89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "09ccc3cedffb49cbdcb8650d4dcc4573ef1c68923b3861201f40cb8ed1cd6a6e"
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
