class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.2.2/dsh-bio-tools-2.2.2-bin.tar.gz"
  sha256 "f19af21955d59fd8e9a99cc826ca74db4a4d2eb2d3d52acc97324e5473458ef5"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "b787bfcbe9d59c0c06eb28b2d6d9d0645535c1365c3912028fdf16f05dc571ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b0348f4facc8b4e497858d84b4b92bc07df52fce71f4560973225769812ea6a"
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
