class Edirect < Formula
  desc "Access NCBI databases via the command-line"
  homepage "https://www.ncbi.nlm.nih.gov/books/NBK179288/"
  url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/edirect.tar.gz"
  version "19.1"
  sha256 "61dc3e5d48d5dfda3de45a76696c5e127c987747f3483fbb7d86a6e3aefe110c"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "c10386ded062448752f32a7271153dfa541061d5ac7f87e0bf50565eaf222794"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "54bb73c126bd6d1094f3b4a26804db44d83ad3afe56f01079b63bba07cee1960"
  end

  depends_on "cpanminus" => :build
  depends_on "openssl"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # macOS CIRCLE-CI often fails on https accesses. Use ftp accesses.
  resource "xtract" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/xtract.Silicon.gz"
      sha256 "b07d1a3d3493a7c4350689743d996d6fd0da399d83cdec1273133f0b6f80f556"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/xtract.Darwin.gz"
      sha256 "3487842955caa32c432f9ea8d91fb4198ebec92b0a15a4104399935eb7425274"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/xtract.Linux.gz"
      sha256 "0532fecb7735e0dc517e5b83ef9613b5a729499183f49f6a907c02ffb978d3c2"
    end
  end

  resource "rchive" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/rchive.Silicon.gz"
      sha256 "ab2a18dac890e0150352b199f22e49f6948312d0d69b8eff25f8722be40aba9f"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/rchive.Darwin.gz"
      sha256 "df8aac651f3ce324304ec4875668b2637193e0f9dfd13962f1da3e682c7dd735"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/rchive.Linux.gz"
      sha256 "020feb9340b10adf12c8b62c7d798e982bdf4e419b247db2bac6351882b0004a"
    end
  end

  resource "transmute" do
    if OS.mac? && Hardware::CPU.arm?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/transmute.Silicon.gz"
      sha256 "ce11412c0d42fe7cd3f56786257258e7ec6921a1207e17a14b8b67425e6d2f8f"
    elsif OS.mac?
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/transmute.Darwin.gz"
      sha256 "af70925a8ae1bd543917db4dc4bd890a8fd15e5eeb90d14bd15b3948cda9e695"
    else
      url "https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/versions/19.1.20230317/transmute.Linux.gz"
      sha256 "75767894069a1b8399ad9560fed9901313711759e14990f9f7fc524132c55544"
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
