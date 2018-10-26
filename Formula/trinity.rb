class Trinity < Formula
  # cite Grabherr_2011: "https://doi.org/10.1038/nbt.1883"
  desc "RNA-Seq de novo assembler"
  homepage "https://trinityrnaseq.github.io"
  url "https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.8.3.tar.gz"
  sha256 "745abda5eafdd98e4625aae6c190975b499695a4ebda537d305fcd0129859823"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "38ba406ba401e8199095fbb0e14f4915e6d5738a8ee5a5fdb6c6b219c96cab04" => :sierra
    sha256 "30b06bb67c0d83b1e54f49642bf438faff43cb12e529928123bed231a91406a4" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "bowtie2"
  depends_on "express"
  depends_on "htslib"
  depends_on :java => "1.8+"
  depends_on "jellyfish"
  depends_on "salmon"
  depends_on "samtools"
  depends_on "trimmomatic"

  fails_with :clang

  # Trinity doesn't link to eXpress, which depends on Boost, built with C++11
  cxxstdlib_check :skip

  def install
    inreplace "Trinity" do |s|
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic/trimmomatic.jar",
        Dir["#{Formula["trimmomatic"].libexec}/trimmomatic*"].first
      s.gsub! "$ROOTDIR/trinity-plugins/Trimmomatic",
        Formula["trimmomatic"].opt_prefix
    end

    inreplace "util/misc/run_jellyfish.pl", '$JELLYFISH_DIR = $FindBin::RealBin . "/../../trinity-plugins/jellyfish-1.1.3";',
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
