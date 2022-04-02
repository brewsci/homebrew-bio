class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0.8/dsh-bio-tools-2.0.8-bin.tar.gz"
  sha256 "916f76fb0667aca55259deaba95df1f6ac132a538eca72358c922ea02562b26c"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "3aff2dd93a8e2a49dc2cf79749f2017e01af87c1f141a5b213eade33b90bd756"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cdee00ca6ea213a544813a588a4433660f807749e9c164ea2031638b452198b"
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
