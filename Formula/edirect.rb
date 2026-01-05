class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/24.7.20250910/edirect-24.7.20250910.tar.gz"
  version "24.7"
  sha256 "cfb67eff0ab1530c8097cddbb98e388b009bb79a117033f9eb79345be48de869"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_tahoe:   "fb2f3b8d7803aece8044bed8304651c9b314c4f4200c5a9498540ab4cbc5673b"
    sha256 arm64_sequoia: "84dcca3919323c011b0ea44e155bcbea5e59e5edcec50af7a9fd3b0b451288f6"
    sha256 arm64_sonoma:  "d2254dfc4f97020b7f4678e04404b9f54dc714c4afe51ac5d8a8a2c3476b9fc7"
    sha256 x86_64_linux:  "ec056ea55921bbd9599c150810476b8b5bee71a8386f4bd7b2fb73dc86532c34"
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
