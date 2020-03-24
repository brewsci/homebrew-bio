class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/12.4.20191101/edirect-12.4.20191101.tar.gz"
  version "12.4"
  sha256 "a88f6fa9518267def78e3092217c5a75fbbc63f39242c3e41011bb41e95656fc"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "37abb2f97bb0260af84499300935e4fec412fcf385d1f2e303eb681876b47877" => :mojave
    sha256 "e2fcc5996db0db2bb916e14d4925883d542271c397bf949f6c45d27b9aa4cc4d" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "openssl@1.1"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "xtract" do
    if OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/12.4.20191101/xtract.Darwin"
      sha256 "416de277a14fbd9e82b3dafad5f9cabbeb34beedc9b283da10e7691d6088ec6f"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/12.4.20191101/xtract.Linux"
      sha256 "63d69e9e93afd1ba8950bd1a15fc0f5f7bac2a196f386705258b84e4951ddcfe"
    end
  end

  resource "rchive" do
    if OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/12.4.20191101/rchive.Darwin"
      sha256 "1d135b88cd7c0cc0737e020831a5cb82d320b7ed4dc8e06a88820d6695c5b025"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/12.4.20191101/rchive.Linux"
      sha256 "edbfad815ed8d1a275fb7d9c75ef284d9423cd39c4fdf7c7a5c017a70bf88ad7"
    end
  end

  def install
    rm %w[Mozilla-CA.tar.gz setup-deps.pl]
    rm Dir["*.go"]
    rm Dir["*.sh"]
    rm Dir["pm-*"]

    %w[rchive xtract].each do |tool|
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
      (bin/name).write_env_script(script, :PERL5LIB => ENV["PERL5LIB"])
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
