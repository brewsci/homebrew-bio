class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.1/dsh-bio-tools-2.1-bin.tar.gz"
  sha256 "cbe0bcf9f37fb61e614de5339d3bb8c7183f87c4afcc9a59f11d369a15a2ca12"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "614d18d57604653c763ef4b0ff6c1d5f8d9ad9a43e1d286cd6e5a12cdc776346"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "38f4abe460e5c8844be0562dc11946b2b607fd1ecfb0c4c71d1986780f8d6e62"
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
