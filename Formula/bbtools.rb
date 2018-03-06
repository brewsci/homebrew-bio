class Bbtools < Formula
  # cite Bushnell_2017: "https://doi.org/10.1371/journal.pone.0185056"
  desc "Brian Bushnell's tools for manipulating reads"
  homepage "https://jgi.doe.gov/data-and-tools/bbtools/"
  url "https://downloads.sourceforge.net/project/bbmap/BBMap_37.93.tar.gz"
  sha256 "21be384f8535094b8b4695134b0b132863e6599811b8ea2d311960b7ba88df8f"

  depends_on "cmake" => :build
  depends_on :java => "1.7"
  depends_on "pigz" => :recommended

  def install
    cd "jni" do
      ENV["JAVA_HOME"] = Formula["jdk"].prefix if ENV["CIRCLECI"]
      system "cmake", ".", *std_cmake_args
      system "make"
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
    system "#{bin}/bbmap.sh 2>&1 | grep -q 'bbushnell.lbl.gov'"
    system "#{bin}/bbduk.sh", "in=#{prefix}/resources/sample1.fq.gz", "in2=#{prefix}/resources/sample2.fq.gz",
                              "out=#{testpath}//R1.fastq.gz", "out2=#{testpath}/R2.fastq.gz",
                              "ref=#{prefix}/resources/phix174_ill.ref.fa.gz",
                              "overwrite=true", "k=31", "hdist=1"
    assert_match "maqb", shell_output("#{bin}/bbmap.sh --help 2>&1")
    assert_match "minkmerhits", shell_output("#{bin}/bbduk.sh --help 2>&1")
  end
end
