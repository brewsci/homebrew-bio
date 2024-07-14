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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "be7e3d045721d59ba82d26b23dcb8c0db6db0ca2df8fbbb6384ce10639f43e83"
    sha256 cellar: :any_skip_relocation, ventura:      "7f20cf2339746cabcc3cc7d82b9edd5043e24e68b8c9b268ae0456a242f9afa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95b8e0d4a264cf3e0f5a74b4de6ff208c3da74cf3f1701371b2d729135dbe685"
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
