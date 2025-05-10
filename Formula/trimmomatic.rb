class Trimmomatic < Formula
  # cite Bolger_2014: "https://doi.org/10.1093/bioinformatics/btu170"
  desc "Flexible read trimming tool for Illumina data"
  homepage "https://github.com/usadellab/Trimmomatic"
  url "https://github.com/usadellab/Trimmomatic/archive/refs/tags/v0.39.tar.gz"
  sha256 "a05e28c3391d6ef55dec40de76bb19ca828c4896f3d6ad72e9659ed6a2229e34"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/usadellab/Trimmomatic.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5080a5a31af4f856cdd01ff0e3ace9ad40bda07670c86fa67753760de39ba15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3574b08bf72a1023c29e44df222546674930b47ca73b4f30081827d170998e97"
    sha256 cellar: :any_skip_relocation, ventura:       "dbca8da6ef14be5458cbf7377878efafa483c00f29f3b6c385205377159ba054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4a80578d15d7dfc9cc3fa1a57e52757f33ef473c57158a2c616279c44c2a1d"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    # Set source and target versions to 1.8
    inreplace "build.xml", "source=\"1.5\" target=\"1.5\"", "source=\"1.8\" target=\"1.8\""
    system "ant"
    system "unzip", "-o", "-d", "dist", "dist/Trimmomatic-#{version}.zip"
    libexec.install Dir["dist/Trimmomatic-#{version}"]
    bin.write_jar_script libexec/"Trimmomatic-#{version}/trimmomatic-#{version}.jar", "trimmomatic", java_version: "11"
    pkgshare.install "adapters"
  end

  def caveats
    <<~EOS
      FASTA file of adapter sequences are located here:
      #{libexec}/Trimmomatic-#{version}/adapters
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
      "ILLUMINACLIP:#{libexec}/Trimmomatic-#{version}/adapters/TruSeq3-SE.fa:2:30:10",
      "LEADING:3",
      "TRAILING:3",
      "SLIDINGWINDOW:4:15",
      "MINLEN:36",
    ].join(" ")
    assert_match "Completed successfully", shell_output("#{command} 2>&1")
  end
end
