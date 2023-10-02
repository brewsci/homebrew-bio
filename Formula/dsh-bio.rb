class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.3/dsh-bio-tools-2.3-bin.tar.gz"
  sha256 "3255ae93cf7ac05ea8c64f1d6301b9bf745094c82f9db2a6345319a6cca2fafd"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "f323b14ab2e3178baeae9966bd3ba2068703c36bf3d7a2fc4800c235f1d7471c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd5d37544204f115fe9fb913f2f93e8b491f8234b91f77fbe582c800f96e40d2"
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
