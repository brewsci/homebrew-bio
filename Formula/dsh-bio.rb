class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/1.4/dsh-bio-tools-1.4-bin.tar.gz"
  sha256 "5ae307725cb3de630d45b656eccce0fc9ef2a33e57db42b184a371d578e7106c"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3fcdcfb1a6084b4cae0abf1fca53a2785654b95c954435a684b99ad62ca859c0" => :catalina
    sha256 "b88996865d3bca29dcea9362021862a8487adb0869bced1a82164150d952992a" => :x86_64_linux
  end

  depends_on java: "1.8+"

  def install
    rm Dir["bin/*.bat"] # Remove all windows files
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/dsh-bio --help")
  end
end
