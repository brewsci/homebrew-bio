class Trinity < Formula
  # cite Grabherr_2011: "https://doi.org/10.1038/nbt.1883"
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.11.0/trinityrnaseq-v2.11.0.FULL.tar.gz"
  version "2.11.0"
  sha256 "230798b3c2eea7043098de3055a1fe150213929b0773e6d374fc0c7219c310c6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "eb48d8f3f5b99ea356a8f20b15fc4ce3a50e54aaf10d8fbc9cfd92d25a178472" => :catalina
    sha256 "369b95ac0b090cdacfffc31791c5eb88a37c5ddc5ee163b3c1f2cbaadf189dd6" => :x86_64_linux
  end

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
    depends_on "libomp"
  end

  # Trinity doesn't link to eXpress, which depends on Boost, built with C++11
  cxxstdlib_check :skip

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

    # args = []
    # args << "CXXFLAGS=-L#{Formula["libomp"].opt_lib} -lomp" if OS.mac?
    if OS.mac?
      ENV.append "CXXFLAGS", "-L#{Formula["libomp"].opt_lib}"
      ENV.append "CXXFLAGS", "-lomp"
    end

    system "make", "all", "plugins", "test" #, *args
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
