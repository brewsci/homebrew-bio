class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v1.0.0.tar.gz"
  sha256 "bf2fc2a8a3b81e2a1fc3d4fe709bdc8bba73c53150362df5dbcc06412b1cc678"
  head "https://github.com/tseemann/abricate.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d7153879084316c88d0cb63ecd67af403a6bb189ec7090b623bc8a092595d9d6" => :catalina
    sha256 "90d725dce929665bd7cb9d2baa2686ff687d56c6e32a486388782c06a3b84671" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "any2fasta"
  depends_on "bioperl"
  depends_on "blast"
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
      (bin/name).write_env_script("#{libexec}/bin/#{name}", :PERL5LIB => ENV["PERL5LIB"])
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
