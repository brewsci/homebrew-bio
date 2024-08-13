class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.4.20240812/edirect-22.4.20240812.tar.gz"
  version "22.4"
  sha256 "3320e0b0859b85ecd21248323c792d671bfed8c9c60b1f414a3e0e3c648d8681"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "f2a3904ab141a63abf3bf6d24522908b0775f401347baa9bfeb0caf01f699945"
    sha256 cellar: :any,                 ventura:      "1a74e2f00b2786c5e118d684298cc1550a7f6f5f9f6c9e2b29e1fd223d29ba98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffd700208bfd426e870907abdd82a46d0b4d3517ab6d21a4efdaca61679b26d4"
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
