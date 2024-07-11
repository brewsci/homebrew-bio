class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/edirect.tar.gz"
  version "22.1"
  sha256 "28d9cc2d353323375a2102e9031e229943d1f1f975f140d0815db3e5a111f235"

  bottle do
    root_url "http://vivace.bi.a.u-tokyo.ac.jp"
    sha256 cellar: :any,                 arm64_sonoma:   "f95e3d2e6a16a83dcc5b01272d04c035728bb9d03fa8a8b35e28ff5d7f3074bb"
    sha256 cellar: :any,                 sonoma:         "b2caec3628c5b6b9a1742f80b09113a86b2543170047f04b72e9caf167ea90b8"
  end

  depends_on "cpanminus" => :build
  depends_on "openssl"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # macOS CIRCLE-CI often fails on https accesses. Use ftp accesses.
  resource "xtract" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/xtract.Silicon.gz"
      sha256 "7c841d4e2aeaf4e095ca721d2a6266422580c8fdfc5f9f33b5c55d3c8d9ca543"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/xtract.Darwin.gz"
      sha256 "394d2af9fe4b5595907b7cce70dd2f2f0a92a6975bb8b1502a7cdeeecbb1cfa2"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/xtract.Linux.gz"
      sha256 "1e97ecfda18e45311c14b1628a097443a0079013ab16da47548d4da696063152"
    end
  end

  resource "rchive" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/rchive.Silicon.gz"
      sha256 "b1035e3ebf0e123303ce58f98ec17395348a3e000844a01223b3734a157ac372"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/rchive.Darwin.gz"
      sha256 "8fd39230d9c9dcd5c3d263201b04b065fbacf09e77e2e75000aaed38ce8f88f5"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/rchive.Linux.gz"
      sha256 "4a0af7405d6fc1da52ec554f4906ad6004d9662316852dd0e5816b3c0f519d5b"
    end
  end

  resource "transmute" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/transmute.Silicon.gz"
      sha256 "031822fede0e89beed8f7041c973ce4af1232e377341697bb6a6501c2dbca779"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/transmute.Darwin.gz"
      sha256 "3dd7724b97a69f12205cbe3b09358d57f3224aadf789251f50b60ed8f3c964df"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/22.1.20240517/transmute.Linux.gz"
      sha256 "295e369d2ab42c62ea289e698513a468a456a67ea6360bb9d7474aa6e1f006c8"
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
