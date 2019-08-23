class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v0.9.3.tar.gz"
  sha256 "a7714ea591d86fd282b53d0146af8af6ab693aec5d1545632ee73feb8605d46f"
  head "https://github.com/tseemann/abricate.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2a0d5ca4c023c3a6861b832a04207e0ff44e895360d2e98b70ed32e3a6575c13" => :sierra
    sha256 "f166e269d2235aed9eb1b8eead6c81abe23e5dc68996639457bf7ae9fe6d15d3" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "any2fasta"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "edirect"
  unless OS.mac?
    depends_on "perl"
    depends_on "unzip"
  end

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    pms = %w[JSON Path::Tiny Time::Piece Text::CSV List::MoreUtils]
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
