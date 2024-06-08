class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.4/dsh-bio-tools-2.4-bin.tar.gz"
  sha256 "c33e10ed24468548ed929dae6bbbaa5cacfb6ab124ef62b93f5a742ca6e7d9c6"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "de39493b6aba8bc1cbbdf1eaa62dbc94d06f83ee9e834e0b9e8f7e274d79e981"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "76bb25a7399d3bc105a7748741718e0ba47521fe1e8341ef6729728426a59c23"
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
