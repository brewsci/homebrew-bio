class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v1.0.1.tar.gz"
  sha256 "5edc6b45a0ff73dcb4f1489a64cb3385d065a6f29185406197379522226a5d20"
  license "GPL-2.0"
  head "https://github.com/tseemann/abricate.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9aa025868b88f8c74aacc177dc6f672bf436654390baea43eaa2bef3de2c561e" => :catalina
    sha256 "6c0477d78fe6c1cef673f51569500b9fbb100502ec99359ad168d5f1d56f5686" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "blast"
  depends_on "brewsci/bio/any2fasta"
  depends_on "brewsci/bio/bioperl"
  depends_on "openssl@1.1" # for Net::SSLeay
  depends_on "perl" # MacOS version too old

  uses_from_macos "unzip"

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix # for Net::SSLeay

    pms = %w[JSON Path::Tiny List::MoreUtils LWP::Simple]
    system "cpanm", "--self-contained", "-l", prefix/"perl5", *pms

    libexec.install Dir["*"]
    %w[abricate abricate-get_db].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  def post_install
    system "#{bin}/abricate", "--setupdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abricate --version")
    assert_match "resfinder", shell_output("#{bin}/abricate --list 2>&1")
    assert_match "--db", shell_output("#{bin}/abricate --help")
    assert_match "OK", shell_output("#{bin}/abricate --check 2>&1")
    assert_match "download", shell_output("#{bin}/abricate-get_db --help 2>&1")
  end
end
