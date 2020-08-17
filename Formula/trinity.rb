class Trinity < Formula
  # cite Grabherr_2011: "https://doi.org/10.1038/nbt.1883"
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.11.0/trinityrnaseq-v2.11.0.FULL.tar.gz"
  sha256 "230798b3c2eea7043098de3055a1fe150213929b0773e6d374fc0c7219c310c6"
  license "BSD-3-Clause"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "aa8ad40994e918b6c20f053501ed87c4fb5585468d6f4c971ba88c788189dd42" => :catalina
    sha256 "964414c050baa9ddb52ef211438197bc95c91e76adc778861fcbda1c366c1afe" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "bowtie2"
  depends_on "brewsci/bio/express"
  depends_on "brewsci/bio/jellyfish"
  depends_on "brewsci/bio/salmon"
  depends_on "brewsci/bio/trimmomatic"
  depends_on "htslib"
  depends_on java: "1.8+"
  depends_on "samtools"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc" # needs openmp
  end

  # Trinity doesn't link to eXpress, which depends on Boost, built with C++11
  cxxstdlib_check :skip

  fails_with :clang # needs openmp

  def install
    ENV.cxx11

    rm_r "Butterfly/Butterfly"
    rm_r "trinity-plugins/bamsifter/htslib"

    inreplace "trinity-plugins/bamsifter/Makefile" do |s|
      s.gsub! "sift_bam_max_cov: sift_bam_max_cov.cpp htslib/version.h",
              "sift_bam_max_cov: sift_bam_max_cov.cpp"
      s.gsub! "-L./htslib/build/lib/", "-L#{Formula["htslib"].opt_lib}"
      s.gsub! "-I./htslib/build/include", "-I#{Formula["htslib"].opt_include}"
    end

    # Fix error: 'string' is not a member of 'std'
    inreplace "trinity-plugins/bamsifter/sift_bam_max_cov.cpp",
              "#include <string.h>",
              "#include <string.h> \n #include <string>"

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
    rm Dir["**/config.log"]
    rm Dir["**/*.tar.gz"]
    rm_r Dir["**/build"]
    rm_r Dir["**/src"]
    libexec.install Dir["*"]
    (bin/"Trinity").write_env_script(libexec/"Trinity", PERL5LIB: libexec/"PerlLib")
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
