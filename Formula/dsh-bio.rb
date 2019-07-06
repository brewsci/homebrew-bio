class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GFA1/2, GFF3, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/1.2/dsh-bio-tools-1.2-bin.tar.gz"
  sha256 "f5ecfc9071c1baaa6ccb3d0643554f4275b49f4112595cec5f32a2bbc9898f39"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e14edc499b5658e6ec688445998c99469a54dbb42a7999ce0ffdf05a548ccc22" => :sierra
    sha256 "d777488f0b5d39d0e73e4b40ba0e7a6f15032de6802b966761bb5ff94c405b8b" => :x86_64_linux
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
