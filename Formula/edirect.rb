class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/25.9.20260617/edirect-25.9.20260617.tar.gz"
  version "25.9"
  sha256 "c34978d32aa09c6c29f6f7612a0b58cfb2af8e3dd9bd9429c8116c0f7ac0dc08"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "249e07ce9f7466a838adab84952a99c54b328c63740bf259c6c5aceaa5e5e501"
    sha256 arm64_sequoia: "f04b6dc4898e16a12e6a2168308b93d67dbae45ec780240da06604640b9dde80"
    sha256 arm64_sonoma:  "0f76a2b29612acd50a3a24d7a5fa397e979fc6981f0ac40cd0342adf3a59c2ac"
    sha256 x86_64_linux:  "c53c7fde829cfe364cb10bee3a4aa199dba941ebb97529bf173c7fca6a0a27e7"
  end

  depends_on "cpanminus" => :build
  depends_on "go" => :build
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "perl"
  uses_from_macos "zlib"

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

    cd "#{libexec}/cmd" do
      system "./build.sh", bin
    end
    cd "#{libexec}/eutils" do
      system "./build.sh", bin
    end
  end

  test do
    %w[efetch esearch einfo efilter epost elink xtract transmute rchive].each do |exe|
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
