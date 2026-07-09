class Prokka < Formula
  # cite Seemann_2014: "https://doi.org/10.1093/bioinformatics/btu153"
  desc "Rapid annotation of prokaryotic genomes"
  homepage "https://github.com/tseemann/prokka"
  url "https://github.com/tseemann/prokka/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "e626d53313401d7c5fac48b41f161c2cf233c8ce6aec844d5ca419e644665df1"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "24e1353aaca147ff545e47cce05ea869a7eeaa7d7e7ad9c16bfb3091461cac7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a2dfcf267d54b5d5325631d28344277969d587450d31ff2b970ed364f61984b"
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
