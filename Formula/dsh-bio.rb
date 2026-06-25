class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/4.0/dsh-bio-tools-4.0-bin.tar.gz"
  sha256 "4e61c8fc5dff674c68eff732adbd8ed4ae208149713337a3b66dd8b28adf76de"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f91ed6923b310a405c8c1027b0b506c4f85bfa129ebcf85b0913ac0cfe21e80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f91ed6923b310a405c8c1027b0b506c4f85bfa129ebcf85b0913ac0cfe21e80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f91ed6923b310a405c8c1027b0b506c4f85bfa129ebcf85b0913ac0cfe21e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fa20770bae9ea2a7dbd230e6fca1832b73509efff65adfaafd890c4dc48cea"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"] # Remove all windows files
    libexec.install Dir["*"]
    Dir["#{libexec}/bin/*"].each do |exe|
      name = File.basename(exe)
      (bin/name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
        exec "#{exe}" "$@"
      EOS
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/dsh-bio --help")
  end
end
