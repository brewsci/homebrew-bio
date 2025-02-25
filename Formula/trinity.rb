class Trinity < Formula
  # cite Grabherr_2011: "https://doi.org/10.1038/nbt.1883"
  desc "RNA-Seq de novo assembler"
  homepage "https://github.com/trinityrnaseq"
  url "https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.15.1/trinityrnaseq-v2.15.1.FULL.tar.gz"
  sha256 "ba37e5f696d3d54e8749c4ba439901a3e97e14a4314a5229d7a069ad7b1ee580"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "f71e98e93d78627e3257df4e1934816a33596d7a7ca490f712999526233ae450"
    sha256 cellar: :any,                 ventura:      "1b7e142197849f8d59333b7cbe50b24e8183900685ddeae6c7fa54c8b90b896c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "671075ec7397e804cfb61e292aa4c7369a2d42446dff971d822cc0cbdec27f46"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "bowtie2"
  depends_on "brewsci/bio/express"
  depends_on "brewsci/bio/salmon"
  depends_on "brewsci/bio/trimmomatic"
  depends_on "htslib"
  depends_on "jellyfish"
  depends_on "openjdk@11"
  depends_on "samtools"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

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

    if OS.mac?
      # Use libomp for Inchworm and Chrysalis
      args = []
      libomp = Formula["libomp"]
      args << "-Xpreprocessor -fopenmp -lomp -m64 -I#{libomp.opt_include}"
      args << "-L#{libomp.opt_lib}"
      inreplace "Inchworm/CMakeLists.txt", "-fopenmp ", "#{args.join(" ")} "
      inreplace "Chrysalis/CMakeLists.txt", "-fopenmp ", "#{args.join(" ")} "
      # Use libomp for third-party plugins
      inreplace "trinity-plugins/Makefile",
                "CXX = g++\nCC = gcc",
                "CXX = clang++\nCC = clang"
      inreplace "trinity-plugins/Makefile",
                "\"-fopenmp\"",
                "\"#{args.join(" ")}\""
    end
    # Fix error: 'string' is not a member of 'std'
    inreplace "trinity-plugins/bamsifter/sift_bam_max_cov.cpp",
              "#include <string.h>",
              "#include <string.h> \n #include <string>"

    # Use Homebrew's trimmomatic
    ver = Formula["trimmomatic"].version
    inreplace "Trinity" do |s|
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic/trimmomatic.jar",
              "#{Formula["trimmomatic"].libexec}/Trimmomatic-#{ver}/trimmomatic-#{ver}.jar"
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic",
              "#{Formula["trimmomatic"].libexec}/Trimmomatic-#{ver}"
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
    envs = {
      PERL5LIB:  libexec/"PerlLib",
      JAVA_HOME: Formula["openjdk@11"].opt_prefix,
    }
    (bin/"Trinity").write_env_script(libexec/"Trinity", envs)
  end

  test do
    cp_r Dir["#{libexec}/sample_data/test_Trinity_Assembly/*.fq.gz"], testpath
    system "#{bin}/Trinity",
      "--no_distributed_trinity_exec", "--bypass_java_version_check",
      "--seqType", "fq", "--max_memory", "1G", "--SS_lib_type", "RF",
      "--left", testpath/"reads.left.fq.gz,reads2.left.fq.gz",
      "--right", testpath/"reads.right.fq.gz,reads2.right.fq.gz"
    assert_path_exists testpath/"trinity_out_dir/both.fa"
  end
end
