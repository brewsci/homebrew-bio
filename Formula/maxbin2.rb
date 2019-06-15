class Maxbin2 < Formula
  # cite Wu_2016: "https://doi.org/10.1093/bioinformatics/btv638"
  desc "Binning algorithm to recover genomes from metagenomic datasets"
  homepage "https://sourceforge.net/projects/maxbin2/"
  url "https://downloads.sourceforge.net/project/maxbin2/MaxBin-2.2.6.tar.gz"
  sha256 "2fdef85a7af175c605be51dd7b410087bf2602945ca692521c06c24d0c90cd30"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9e9f738f0db2854c22c3ffff3ccf26d8e9ca26eb9fe0dee3bcf0391a93a889b7" => :sierra
    sha256 "8d365882abbddfe35395b365e80981a89b6fe4af868bfd9f743b55d02e04b894" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "bowtie2"
  depends_on "fraggenescan"
  depends_on "hmmer"
  depends_on "idba"
  depends_on "perl" unless OS.mac?
  depends_on "openssl"

  def install
    ENV.prepend_path "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    system "cpanm", "--self-contained", "-l", prefix/"perl5", "IO::Socket::SSL", "LWP::Simple"
    system "make", "-C", "src"
    (libexec/"src").install "src/MaxBin"
    rm_r "src"
    libexec.install Dir["*"]
    (bin/"maxbin2").write_env_script libexec/"run_MaxBin.pl", :PERL5LIB => ENV["PERL5LIB"]
  end

  def caveats; <<~EOS
    The main executable is installed as `maxbin2`. All other executable files
    are installed to `#{libexec}`.
  EOS
  end

  test do
    assert_match "Usage", shell_output("perl #{libexec}/run_MaxBin.pl 2>&1")
  end
end
