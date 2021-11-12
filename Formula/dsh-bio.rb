class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0.6/dsh-bio-tools-2.0.6-bin.tar.gz"
  sha256 "331afe5f1804a20a3c24dd00ed4597c3dc380257265d86afe3ca8d46188884d9"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "c17fdd3a27c571770a54b2c1e8d99bf1794bd6545e43b771983f8b9b2f01f48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e25b8ea4afd9243d4fa20fb2fb55e02393aff042348c65c14f67b5a317aac43c"
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
