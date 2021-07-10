class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/edirect.tar.gz"
  version "15.3"
  sha256 "48c3bd6ea6f8b9d3136b9a4e1b63910314d14df308f6744c01a4df77e898e628"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "d24f466c08c865c1866212c03969c0597512ede63f0193e1dd1fef31f8e6de16"
    sha256 cellar: :any, x86_64_linux: "ef5637b3c12ad99ef415c38c441f00537b0bea6bffb615253cc3ca477d0b741d"
  end

  depends_on "cpanminus" => :build
  depends_on "openssl@1.1"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # macOS CIRCLE-CI often fails on https accesses. Use ftp accesses.
  resource "xtract" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/xtract.Silicon.gz"
      sha256 "37317b1ec2f2d3abfa9a7eaed60730d1a7ee8b1125718348d3b3133d9f401431"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/xtract.Darwin.gz"
      sha256 "19f898637e33fa085af0b21d773d35d74ec0f404e02379bcaa7f7c507fcbd884"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/xtract.Linux.gz"
      sha256 "998713ac9ba0b0fa258821aef05c83a046bf3131f22bf13c0a2495b31c55bbd5"
    end
  end

  resource "rchive" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/rchive.Silicon.gz"
      sha256 "b12f6930e4fd6873e89607187f8c5ba78bb63921b84d10f3710adbec2f644908"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/rchive.Darwin.gz"
      sha256 "002cc1e57d1545ba173d7498ad1dcefbf3d5965f91d0b3d6e03e1bc38b9d2873"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/rchive.Linux.gz"
      sha256 "1c56a5da7432e95fb53be5aeba940f7345fd0cb4f6bf2121294dd534919f6f40"
    end
  end

  resource "transmute" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/transmute.Silicon.gz"
      sha256 "97a5d95b9840e5316bfec7f318d2721802fd7cf2b528fb207278dd5d48a1bc63"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/transmute.Darwin.gz"
      sha256 "38efb39d177557fbe94f0f039c47d68861a78b1139376c01abb41aedd658660e"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/15.3.20210707/transmute.Linux.gz"
      sha256 "fd59d926daeec62c80717546a9615edee65fce7ee2c417dbc88ac9611caf4bb9"
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
