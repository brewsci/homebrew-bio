class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/9.70.20180816/edirect-9.70.20180816.tar.gz"
  version "9.70"
  sha256 "8c5f383ee1943656d0b74e88eb661c7ee1f45579b03f84ee46b8c7859d7f3b99"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "fedb6269dd75de7b178f79701caf3438eddfbece091943b77d34bbba6194f300" => :sierra
    sha256 "ad8e9d21c9c7a70b1a583afcee85f2a27cceb6ec1778c067888f792242fc20dc" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "openssl"
  depends_on "perl"
  depends_on "zlib" unless OS.mac?

  def install
    rm %w[Mozilla-CA.tar.gz setup.sh setup-deps.pl]
    rm Dir["*.go"]
    rm Dir["pm-*"]

    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix # for Net::SSLeay
    pms = %w[Encode::Locale File::Listing HTML::Parser HTML::Tagset HTML::Entities HTML::Tree
             HTTP::Cookies HTTP::Date HTTP::Message HTTP::Negotiate LWP::MediaTypes IO::Socket::SSL
             LWP::Protocol::https URI WWW::RobotRules Mozilla::CA Net::SSLeay]
    system "cpanm", "--self-contained", "-l", prefix/"perl5", *pms

    libexec.install Dir["*"]
    Dir[libexec/"*"].each do |script|
      name = File.basename script
      (bin/name).write_env_script(script, :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    %w[efetch esearch einfo efilter epost elink].each do |exe|
      assert_match version.to_s, shell_output("#{bin}/#{exe} -version")
    end
    # >XP_024459497.1 lycopene epsilon cyclase, chloroplastic isoform X3 [Populus trichocarpa]
    # MECVGARNFGAMAAVLLSCPCPVWRSKTGVATQPQSSSSSSSAKQSVFNSNKRYRLCKVRSGGGSNSSRG
    assert_match "PQSSSSSSSAK",
      shell_output("#{bin}/esearch -db protein -query XP_024459497.1 | #{bin}/efetch -format fasta")
  end
end
