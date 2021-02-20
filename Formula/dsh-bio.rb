class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0.2/dsh-bio-tools-2.0.2-bin.tar.gz"
  sha256 "eada488d7aa863ce187473512f85be9a0ce6a0b50a6ecf66c23c0ee72908747e"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "7bcf5fbdca9723385ea257092d4bc5b9d051b2aad315ada4808fcb39d756c93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "80a22439485ccfe318db475dd29e0fd7a21f3fc284b3a243c517cc27218411db"
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
