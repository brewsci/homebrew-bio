class Maxbin2 < Formula
  # cite Wu_2016: "https://doi.org/10.1093/bioinformatics/btv638"
  desc "Binning algorithm to recover genomes from metagenomic datasets"
  homepage "https://sourceforge.net/projects/maxbin2/"
  url "https://downloads.sourceforge.net/project/maxbin2/MaxBin-2.2.7.tar.gz"
  sha256 "cb6429e857280c2b75823c8cd55058ed169c93bc707a46bde0c4383f2bffe09e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "41ef87f87c8800b73611d08c43dbb5f139849bbe76782f6d9d70b9bce4b39718" => :catalina
    sha256 "44a8bd3c9afced43635b7c7ae1663b15f67171dde17e0c5a04ce4713cbf33b33" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "cpanminus" => :build
  depends_on "bowtie2"
  depends_on "brewsci/bio/bioperl"
  depends_on "brewsci/bio/fraggenescan"
  depends_on "brewsci/bio/idba"
  depends_on "hmmer"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  def install
    ENV.prepend_path "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    system "cpanm", "--self-contained", "-l", prefix/"perl5", "IO::Socket::SSL", "LWP::Simple"
    system "make", "-C", "src"
    (libexec/"src").install "src/MaxBin"
    rm_r "src"
    libexec.install Dir["*"]
    (bin/"maxbin2").write_env_script libexec/"run_MaxBin.pl", PERL5LIB: ENV["PERL5LIB"]
  end

  def caveats
    <<~EOS
      The main executable is installed as `maxbin2`. All other executable files
      are installed to `#{libexec}`.
    EOS
  end

  test do
    assert_match "Usage", shell_output("perl #{libexec}/run_MaxBin.pl 2>&1")
  end
end
