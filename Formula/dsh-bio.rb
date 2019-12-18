class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GFA1/2, GFF3, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/1.3/dsh-bio-tools-1.3-bin.tar.gz"
  sha256 "3c58841f9be74c7ae71ef6e009230e2cb1011d3771c87f7c0276860bf677d3ee"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a1be0d419c4ebc43bf2cfd5354b81a753b2222dd3a595d253d38ba382e2aaf5a" => :sierra
    sha256 "11e5829cc90fecf7b59e4b7590fd44d8c9d9b2cdd423fb74399e30a6be469a0b" => :x86_64_linux
  end

  depends_on :java => "1.8+"

  def install
    rm Dir["bin/*.bat"] # Remove all windows files
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/dsh-bio --help")
  end
end
