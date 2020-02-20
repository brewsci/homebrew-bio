class Nullarbor < Formula
  desc "Public health microbiology reports from sequenced isolates"
  homepage "https://github.com/tseemann/nullarbor"
  url "https://github.com/tseemann/nullarbor/archive/v2.0.20191013.tar.gz"
  sha256 "7c547057eef8545f30e2173863dbfee0d85fe100c88f0aa9c706229fa30f57f2"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cpanminus" => :build
  depends_on "openssl@1.1" => :build
  depends_on "pkg-config" => :build

  depends_on "abricate"
  depends_on "any2fasta"
  depends_on "bioperl"
  depends_on "centrifuge"
  depends_on "emboss"
  depends_on "fasttree"
  depends_on "iqtree"
  depends_on "kraken"
  depends_on "kraken2"
  depends_on "mash"
  depends_on "megahit"
  depends_on "mlst"
  depends_on "newick-utils"
  depends_on "perl"
  depends_on "prokka"
  depends_on "quicktree"
  depends_on "seqtk"
  depends_on "shovill"
  depends_on "skesa"
  depends_on "snippy"
  depends_on "snp-dists"
  depends_on "spades"
  depends_on "trimmomatic"
  depends_on "velvet"

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    pms = %w[Module::Build Moo SVG JSON YAML::Tiny Path::Tiny Text::CSV List::MoreUtils]
    ENV["OPENSSL_PREFIX"] = Formula["openssl"].opt_prefix # for Net::SSLeay
    system "cpanm", "--self-contained", "-l", prefix/"perl5", *pms

    libexec.install Dir["*"]
    %w[nullarbor.pl nullarbor-report.pl].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullarbor.pl --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/nullarbor-report.pl --version 2>&1")
    system "#{bin}/nullarbor.pl", "--check"
  end
end
