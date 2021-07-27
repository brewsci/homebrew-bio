class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0.5/dsh-bio-tools-2.0.5-bin.tar.gz"
  sha256 "3269d7ab7de2db68ae63bbba0047d76f0a6e6885df958218a196f0c3165ed6fa"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "9497cb0a33b75adf770c519d321b7ab2c349bb5e44e347afe9a3c3d46c8e61d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "39c146aea66ba1d64ab07587abfea71783f0cb696c2f803a4b2fd7e06306ba91"
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
