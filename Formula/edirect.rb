class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/8.50.20180418/edirect-8.50.20180418.tar.gz"
  version "8.50"
  sha256 "d31658b5b692acd1a6b5199fb45484b20484eb9f822f3cdd185feb54e2ded39b"

  depends_on "cpanminus" => :build
  depends_on "openssl"
  depends_on "perl" unless OS.mac?

  def install
    rm %w[Mozilla-CA.tar.gz setup.sh setup-deps.pl]
    rm Dir["*.go"]
    rm Dir["pm-*"]

    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix # for Net::SSLeay
    pms = %w[Encode::Locale File::Listing HTML::Parser HTML::Tagset HTML::Tree
             HTTP::Cookies HTTP::Date HTTP::Message HTTP::Negotiate LWP::MediaTypes
             LWP::Protocol::https Net::HTTP URI WWW::RobotRules Mozilla::CA]
    system "cpanm", "--self-contained", "-l", prefix/"perl5", *pms

    libexec.install Dir["*"]
    Dir[libexec/"*"].each do |script|
      name = File.basename script
      (bin/name).write_env_script(script, :PERL5LIB => ENV["PERL5LIB"])
    end

    doc.install "README"
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
