class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v0.8.10.tar.gz"
  sha256 "b6724df558e5ee68c48696356035ba2c5911eb5f0176c42ffb129be1941b6b68"
  head "https://github.com/tseemann/abricate.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1dc04fd025ac6dc6b4919d7b98cc595390939aeb32c6f6ffab57db53c25f6a48" => :sierra
    sha256 "611d560a8af672f9b958e5c2df19adfe2e407a7e5170e1bdaef8967992f54548" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "blast"
  depends_on "emboss"
  unless OS.mac?
    depends_on "perl"
    depends_on "unzip"
  end

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    pms = %w[JSON Time::Piece Text::CSV List::MoreUtils]
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
