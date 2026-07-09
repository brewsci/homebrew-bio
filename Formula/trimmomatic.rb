class Trimmomatic < Formula
  # cite Bolger_2014: "https://doi.org/10.1093/bioinformatics/btu170"
  desc "Flexible read trimming tool for Illumina data"
  homepage "https://github.com/usadellab/Trimmomatic"
  url "https://github.com/usadellab/Trimmomatic/archive/refs/tags/v0.41.tar.gz"
  sha256 "ad4cd81f665a6b8b066fc9513cd4a13612fa98f06ada27988473248ee6110ad3"
  license "GPL-3.0-or-later"
  head "https://github.com/usadellab/Trimmomatic.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3795dbc1d4736d6be4f8ba00175a1dc32096bb2083c49ed5e653520d70596171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72a367e33d5652cc6d9465fd476707f48af215085284311d0ae6e51f86f44fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e341bfd840706617499aaf63420106cb5e649e08371fdcff04b23c7739d24cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b97c706eb6f439a3ba1b37cf640519f71cb8051e4295782e7d04eadb9da5ea7e"
  end

  depends_on "maven" => :build
  depends_on "openjdk@26"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@26")
    system "mvn", "clean", "package"
    libexec.install "target/trimmomatic-#{version}.jar"
    bin.write_jar_script libexec/"trimmomatic-#{version}.jar", "trimmomatic", java_version: "26"
    pkgshare.install "adapters"
  end

  def caveats
    <<~EOS
      FASTA file of adapter sequences are located here:
      #{libexec}/trimmomatic-#{version}/adapters
    EOS
  end

  test do
    (testpath/"test.fq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS
    command = [
      "#{bin}/trimmomatic SE -phred33 #{testpath}/test.fq",
      "/dev/null",
      "ILLUMINACLIP:#{pkgshare}/adapters/TruSeq3-SE.fa:2:30:10",
      "LEADING:3",
      "TRAILING:3",
      "SLIDINGWINDOW:4:15",
      "MINLEN:36",
    ].join(" ")
    assert_match "Completed successfully", shell_output("#{command} 2>&1")
  end
end
