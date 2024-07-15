class Prokka < Formula
  # cite Seemann_2014: "https://doi.org/10.1093/bioinformatics/btu153"
  desc "Rapid annotation of prokaryotic genomes"
  homepage "https://github.com/tseemann/prokka"
  url "https://github.com/tseemann/prokka/archive/refs/tags/v1.14.6.tar.gz"
  sha256 "f730b5400ea9e507bfe6c5f3d22ce61960a897195c11571c2e1308ce2533faf8"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "992e481c64fb2c63e228f0bf8b1a98926fd7461305d371625736bf53ce863d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33840d6123d3d8713a223a136455ec57028fc28564d7f386b10c981158166935"
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "brewsci/bio/aragorn"
  depends_on "brewsci/bio/barrnap"
  depends_on "brewsci/bio/infernal"
  depends_on "brewsci/bio/minced"
  depends_on "hmmer"
  depends_on "parallel"
  depends_on "perl"
  depends_on "prodigal"

  def install
    # remove all bundled stuff and use brew ones
    rm_r "binaries"
    # remove non-user scripts
    rm "bin/prokka-build_kingdom_dbs"
    rm "bin/prokka-make_tarball"
    # remove need to install XML::Simple for most cases
    inreplace "bin/prokka", "use XML::Simple;\n", ""
    inreplace "bin/prokka", 'msg("Running RNAmmer");', "require XML::Simple;"
    # patch in brewed bioperl path
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    prefix.install Dir["*"]
    Dir[bin/"*"].each do |exe|
      inreplace exe, "###BREWCONDA###", "use lib '#{bioperl}';"
    end
  end

  def post_install
    system "#{bin}/prokka", "--setupdb"
  end

  def caveats
    <<~EOS
      This formula doesn't contain tbl2asn because it is deprecated now.
      See https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/ for details.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prokka --version 2>&1")
    assert_match "Kingdoms:", shell_output("#{bin}/prokka --listdb 2>&1")
    assert_match "genetic", shell_output("#{bin}/prokka-genbank_to_fasta_db --help 2>&1", 1)
  end
end
