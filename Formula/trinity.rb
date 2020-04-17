class Trinity < Formula
  # cite Grabherr_2011: "https://doi.org/10.1038/nbt.1883"
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.8.6.tar.gz"
  sha256 "cff2255e1c6aac54908598ea5ca33cd9767675de478664a53045d431f5ac3c2b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ecfa16c3838733387305b4a3ca1c34cf8359e94cf2882afdc3f93f408a61e639" => :catalina
    sha256 "8987dbbccf081049203aa253c36d61e4ba1b26fb80e7ca7a5677153604278994" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "bowtie2"
  depends_on "express"
  depends_on "htslib"
  depends_on :java => "1.8+"
  depends_on "jellyfish"
  depends_on "salmon"
  depends_on "samtools"
  depends_on "trimmomatic"

  uses_from_macos "zlib"

  # Trinity doesn't link to eXpress, which depends on Boost, built with C++11
  cxxstdlib_check :skip

  fails_with :clang # needs openmp

  on_macos do
    depends_on "gcc" # needs openmp
  end

  def install
    inreplace "Trinity" do |s|
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic/trimmomatic.jar",
        Dir["#{Formula["trimmomatic"].libexec}/trimmomatic*"].first
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic",
        Formula["trimmomatic"].opt_prefix
    end

    inreplace "util/misc/run_jellyfish.pl",
      '$JELLYFISH_DIR = $FindBin::RealBin . "/../../trinity-plugins/jellyfish-1.1.3";',
      "$JELLYFISH_DIR = \"#{Formula["jellyfish"].opt_prefix}\";"

    system "make", "all", "plugins", "test"
    libexec.install Dir["*"]
    (bin/"Trinity").write_env_script(libexec/"Trinity", :PERL5LIB => libexec/"PerlLib")
  end

  test do
    cp_r Dir["#{libexec}/sample_data/test_Trinity_Assembly/*.fq.gz"], "."
    system "#{bin}/Trinity",
      "--no_distributed_trinity_exec", "--bypass_java_version_check",
      "--seqType", "fq", "--max_memory", "1G", "--SS_lib_type", "RF",
      "--left", "reads.left.fq.gz,reads2.left.fq.gz",
      "--right", "reads.right.fq.gz,reads2.right.fq.gz"
  end
end
