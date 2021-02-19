class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0/dsh-bio-tools-2.0-bin.tar.gz"
  sha256 "eb4bbad0665b7139cbcf92404329ac462ca7e7602d616e66651fb5b13d0b5cab"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "616321b8730090585d15c6b400dfd70529977c88a54997ab94f455f1b47d6846"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ddd1b2ec7e0d79cd135974502b1358c87c8366af48ebe08309577d95959d8dd3"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"] # Remove all windows files
    libexec.install Dir["*"]
    Dir["#{libexec}/bin/*"].each do |exe|
      name = File.basename(exe)
      (bin/name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "#{exe}" "$@"
      EOS
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/dsh-bio --help")
  end
end
