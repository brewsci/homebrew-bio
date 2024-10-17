class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.8.20241011/edirect-22.8.20241011.tar.gz"
  version "22.8"
  sha256 "4fe5ff4edfa9a9ce3c86aae787f46f12aa4ca57ebcb7672f9976aa50364e1789"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sonoma: "515b061df514fa20a13eb2965998f33c6efd85484d3a20ece4fc0f5e9e6da0a9"
    sha256 ventura:      "c3c27a1d549884bb5d78f605f2a893e0c9657dc13a9deec114617005599f0695"
    sha256 x86_64_linux: "836b1c7a5dfe5ca5e7d0d2bf90ae83cce92c8af09fd3613a3e1bcae66a52692b"
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
    cd "#{libexec}/extern" do
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
