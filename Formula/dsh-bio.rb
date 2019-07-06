class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GFA1/2, GFF3, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/1.2/dsh-bio-tools-1.2-bin.tar.gz"
  sha256 "f5ecfc9071c1baaa6ccb3d0643554f4275b49f4112595cec5f32a2bbc9898f39"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b83836cbd771ddc9257dace410a5382cb9aeb3be244b04ed3da1738ebb42ce12" => :sierra
    sha256 "95ddddbaef4e910c6c679f9f27abeecd5874aab5036deb91ec7195d258e79db0" => :x86_64_linux
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
