class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/13.8.20200827/edirect-13.8.20200827.tar.gz"
  version "13.8"
  sha256 "2f9f7441af1bae0c39a5c09567dc46ebe60bb8bad0e399a196284038633dc735"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d24f466c08c865c1866212c03969c0597512ede63f0193e1dd1fef31f8e6de16" => :catalina
    sha256 "ef5637b3c12ad99ef415c38c441f00537b0bea6bffb615253cc3ca477d0b741d" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "openssl@1.1"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "xtract" do
    if OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/13.8.20200827/xtract.Darwin"
      sha256 "349f209aa4f77173959a562ea55f32d957bc57f1b2b3fdf7eeca03b88d42ab66"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/13.8.20200827/xtract.Linux"
      sha256 "9a53c7f07104194d8328cdf711de6150ae0e4de89d6895dac3b61be083b9bfcc"
    end
  end

  resource "rchive" do
    if OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/13.8.20200827/rchive.Darwin"
      sha256 "0d9123cacd04737f0389e1a47cd89662df113eaaf41261d5212b8430ce4308c8"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/13.8.20200827/rchive.Linux"
      sha256 "9ec04876460db44a82840186f983d017b464eeafc013da7c5e21c39c35df3701"
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
