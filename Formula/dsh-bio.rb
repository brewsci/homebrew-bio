class DshBio < Formula
  desc "Tools for BED, FASTA, FASTQ, GAF, GFA1/2, GFF3, PAF, SAM, and VCF files"
  homepage "https://github.com/heuermh/dishevelled-bio"
  url "https://search.maven.org/remotecontent?filepath=org/dishevelled/dsh-bio-tools/2.0/dsh-bio-tools-2.0-bin.tar.gz"
  sha256 "eb4bbad0665b7139cbcf92404329ac462ca7e7602d616e66651fb5b13d0b5cab"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3fcdcfb1a6084b4cae0abf1fca53a2785654b95c954435a684b99ad62ca859c0" => :catalina
    sha256 "b88996865d3bca29dcea9362021862a8487adb0869bced1a82164150d952992a" => :x86_64_linux
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
