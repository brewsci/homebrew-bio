class Bbtools < Formula
  desc "Suite of Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.86.tar.gz"
  sha256 "c3e641285c70fdabbf5f05833241f6a4ee42cd244245ebf8eb32f12341fdf1de"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d321c705775592719ac53b7d2e89aff8a02087c262b293ba2dc265332f5f6bb9" => :catalina
    sha256 "edebab140175eb6a45b4707549b563bb61fd65023f410662713b5718d2dda620" => :x86_64_linux
  end

  depends_on java: "1.7+"

  def install
    if OS.mac?
      system "make", "--directory=jni", "-f", "makefile.osx"
    elsif OS.linux?
      system "make", "--directory=jni", "-f", "makefile.linux"
    end
    prefix.install %w[current jni resources]
    # shell scripts look for ./{current,jni,resources} files, so keep shell scripts
    # in ./#{prefix} but place symlinks in the ../bin dir for brew to export #{bin}
    bin.mkpath
    prefix.install Dir["*.sh"]
    bin.install_symlink Dir["#{prefix}/*.sh"]
    doc.install %w[license.txt README.md docs/changelog.txt docs/Legal.txt docs/readme.txt docs/ToolDescriptions.txt]
  end

  test do
    res = prefix/"resources"
    args = %W[in=#{res}/sample1.fq.gz
              in2=#{res}/sample2.fq.gz
              out=R1.fastq.gz
              out2=R2.fastq.gz
              ref=#{res}/phix174_ill.ref.fa.gz
              k=31
              hdist=1]
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
