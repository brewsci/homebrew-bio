class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/edirect.tar.gz"
  version "16.2"
  sha256 "db1e75b4ecbb9dac6fbee905830f7d8f22b9769878e7fcef1b48ff2bfc484d13"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "c10386ded062448752f32a7271153dfa541061d5ac7f87e0bf50565eaf222794"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "54bb73c126bd6d1094f3b4a26804db44d83ad3afe56f01079b63bba07cee1960"
  end

  depends_on "cpanminus" => :build
  depends_on "openssl"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # macOS CIRCLE-CI often fails on https accesses. Use ftp accesses.
  resource "xtract" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/xtract.Silicon.gz"
      sha256 "bf688a60d71436ebdb89b5c379fbc846c0db6248eaa71a09beaf8c9cce799358"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/xtract.Darwin.gz"
      sha256 "bdef978e624a5e7be9bf8f750cfd71b13c78f3bfe0a1fbb68a0b12364e34e35e"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/xtract.Linux.gz"
      sha256 "edb1ec540a071d67f0253e7ecb327c39d58385c07f5b1a2817735a52315280f0"
    end
  end

  resource "rchive" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/rchive.Silicon.gz"
      sha256 "26d409abc54546b303fd0b36bd3acb105504ac5dc1029bd3a3e2b2bf9e2b6f55"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/rchive.Darwin.gz"
      sha256 "45cf159995a026cd65e0a996110a81f76bfa4a84ef507e51fd22a9baf43bd4fd"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/rchive.Linux.gz"
      sha256 "511b8f1150943541d634cb79cc9de78be1fe741a79d10b4d1ebb1fc6ed1d1a29"
    end
  end

  resource "transmute" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/transmute.Silicon.gz"
      sha256 "1d7b2f061cd75eab3087b8d4bb2fb024bd68676563884e9df6fcec4ed221f5e5"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/transmute.Darwin.gz"
      sha256 "2a6bda5215e6eecde22b9006bd04687941e0ff35eaa8a25bacb859a072b901a8"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/16.2.20211103/transmute.Linux.gz"
      sha256 "8bb83618bb38574745cf0e34d3ed2576ce0219ccd8e9d1f855a75b3ec71b57f1"
    end
  end

  def install
    rm %w[Mozilla-CA.tar.gz]
    rm Dir["*.go"]
    libexec.install "ecommon.sh"
    rm Dir["*.sh"]
    rm Dir["pm-*"]

    %w[rchive xtract transmute].each do |tool|
      inreplace tool, "PATH=", "PATH=#{bin}:"
      inreplace tool, "compiled=$0", "compiled=#{bin}/#{tool}"
    end

    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix # for Net::SSLeay
    pms = %w[XML::Simple Encode::Locale File::Listing HTML::Parser HTML::Tagset HTML::Entities HTML::Tree
             HTTP::Cookies HTTP::Date HTTP::Message HTTP::Negotiate LWP::MediaTypes IO::Socket::SSL
             LWP::Protocol::https URI WWW::RobotRules Mozilla::CA Net::SSLeay]
    ENV.deparallelize
    system "cpanm", "--notest", "--self-contained", "-l", prefix/"perl5", *pms

    libexec.install Dir["*"]
    Dir[libexec/"*"].each do |script|
      name = File.basename script
      (bin/name).write_env_script(script, PERL5LIB: ENV["PERL5LIB"])
    end
    bin.install resource("xtract")
    bin.install resource("rchive")
  end

  test do
    %w[efetch esearch einfo efilter epost elink].each do |exe|
      assert_match version.to_s, shell_output("#{bin}/#{exe} -version")
    end
    # CIRCLE-CI MacOS often fails on https accesses
    unless OS.mac?
      # >XP_024459497.1 lycopene epsilon cyclase, chloroplastic isoform X3 [Populus trichocarpa]
      # MECVGARNFGAMAAVLLSCPCPVWRSKTGVATQPQSSSSSSSAKQSVFNSNKRYRLCKVRSGGGSNSSRG
      assert_match "PQSSSSSSSAK",
        shell_output("#{bin}/esearch -db protein -query XP_024459497.1 | #{bin}/efetch -format fasta")
    end
  end
end
