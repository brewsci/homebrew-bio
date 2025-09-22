class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/24.7.20250910/edirect-24.7.20250910.tar.gz"
  version "24.7"
  sha256 "cfb67eff0ab1530c8097cddbb98e388b009bb79a117033f9eb79345be48de869"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "f5159c6010767dbd381c2f4e593203f9e77a6cebade22cca2cf5fb62a3c781cb"
    sha256 arm64_sonoma:  "4e95e35caca99d06c8d00abeb5b1e0695fdf92da7e46bdac7e5e236856a71392"
    sha256 ventura:       "c44a929f70186ac74fd9ac280d941a2ab5657c4e9fcd66e807268d3988babf27"
    sha256 x86_64_linux:  "1d19222885247e1a4e769d2a6d73cb75243d066111d0248fa35aca8ffc4c0fab"
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
