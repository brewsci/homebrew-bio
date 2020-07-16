class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GFA1/2, GFF3, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/1.3.3/dsh-bio-tools-1.3.3-bin.tar.gz"
  sha256 "fbf40e22363728867b2180d76b5c7f82eb45d672c95b059344c261aec195c36c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "42cffa5de3ad131f6c29a69843aad16dc939bb6790b3b7bfab0ee7ef88dda6a9" => :catalina
    sha256 "e8809d4f7a4cbe09516612c34e21ba8bd94e0d44c448031661e48816f6868cf4" => :x86_64_linux
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
