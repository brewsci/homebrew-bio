class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/3.0/dsh-bio-tools-3.0-bin.tar.gz"
  sha256 "6bb942a29bce10486b242dc379847d1dbeae2a33415f9fbf08fb2cb12491102e"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ca54db849c9d67a85833b8098b5c2bc70b2b7e9479abf116428e989e94d85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ca54db849c9d67a85833b8098b5c2bc70b2b7e9479abf116428e989e94d85e"
    sha256 cellar: :any_skip_relocation, ventura:       "d4ca54db849c9d67a85833b8098b5c2bc70b2b7e9479abf116428e989e94d85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54f821a023eefe445bb0a06244dcecf3f3a99abf8750defe08c81a51c25cde9"
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
