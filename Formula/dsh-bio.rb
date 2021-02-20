class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0.2/dsh-bio-tools-2.0.2-bin.tar.gz"
  sha256 "eada488d7aa863ce187473512f85be9a0ce6a0b50a6ecf66c23c0ee72908747e"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "4da0438d494a1c4897a01adb47a8cfea7f8d140a70e774a7454eef22e5796230"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "febec05d651d22b4d0dd27d034761546bcd972eb85e9fe231c4dfc16cb802f05"
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
