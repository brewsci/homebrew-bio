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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e7e1b699df3c72f397b0b1eff0c549b53c7aeb132fb1117e912878ae1f23401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7e1b699df3c72f397b0b1eff0c549b53c7aeb132fb1117e912878ae1f23401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a442b93032e2780b7332735041f51d30d8953d212b062037a53b8f5a55a3f0"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    system "mvn", "clean", "package", "-DskipTests"
    libexec.install "target/trimmomatic-#{version}.jar"
    bin.write_jar_script libexec/"trimmomatic-#{version}.jar", "trimmomatic"
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
