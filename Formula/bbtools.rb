class Bbtools < Formula
  desc "Suite of Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/bbmap/BBMap_38.59.tar.gz"
  sha256 "0562634cbff0376d5412ad50e10bb0424c4d0b5d29c9b62efbe69fdd4509607d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "de114b9cac2dc1c82fdec73d78b5a7253ff1859d1a9a9e1dbbbf38e0ebb499fd" => :sierra
    sha256 "aec7994d744031765a80c489bc3bf9ad6464c3b36e72201b85779261f4ff9fb1" => :x86_64_linux
  end

  depends_on :java => "1.7+"

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
    args = %W[in=#{res}/sample1.fq.gz in2=#{res}/sample2.fq.gz out=R1.fastq.gz out2=R2.fastq.gz ref=#{res}/phix174_ill.ref.fa.gz k=31 hdist=1]
    system "#{bin}/bbduk.sh", *args
    assert_match "bbushnell@lbl.gov", shell_output("#{bin}/bbmap.sh")
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
