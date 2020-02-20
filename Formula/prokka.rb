class Prokka < Formula
  # cite Seemann_2014: "https://doi.org/10.1093/bioinformatics/btu153"
  desc "Rapid annotation of prokaryotic genomes"
  homepage "https://github.com/tseemann/prokka"
  url "https://github.com/tseemann/prokka/archive/v1.14.6.tar.gz"
  sha256 "f730b5400ea9e507bfe6c5f3d22ce61960a897195c11571c2e1308ce2533faf8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "992e481c64fb2c63e228f0bf8b1a98926fd7461305d371625736bf53ce863d1f" => :catalina
    sha256 "33840d6123d3d8713a223a136455ec57028fc28564d7f386b10c981158166935" => :x86_64_linux
  end

  depends_on "aragorn"
  depends_on "barrnap"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "infernal"
  depends_on "minced"
  depends_on "parallel"
  depends_on "perl"
  depends_on "prodigal"
  depends_on "tbl2asn"

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

  test do
    assert_match version.to_s, shell_output("#{bin}/prokka --version 2>&1")
    assert_match "Kingdoms:", shell_output("#{bin}/prokka --listdb 2>&1")
    assert_match "genetic", shell_output("#{bin}/prokka-genbank_to_fasta_db --help 2>&1", 1)
    system "#{bin}/prokka", "--cpus=2", "--prefix=prokka",
      "--outdir=#{testpath}/prokka", "#{prefix}/test/plasmid.fna"
    assert_predicate testpath/"prokka/prokka.gff", :exist?
  end
end
