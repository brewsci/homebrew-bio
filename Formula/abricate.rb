class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v0.9.7.tar.gz"
  sha256 "e653c019bf140587b69fd4ce55a057c23a95e1f190dbb4a1a8ea86ad030ed777"
  head "https://github.com/tseemann/abricate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42aa3ebe90c27163ed2b0f96c54ae45c7ddb2842b02cc24872288b06e082a6c9" => :sierra
    sha256 "e2521d3d7b7de56ca34af5b7eb724e7dace499026a8f2bc721f7e868dc2a6107" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "any2fasta"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "openssl" # for Net::SSLeay
  depends_on "perl" # MacOS version too old
  depends_on "unzip" unless OS.mac?

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
