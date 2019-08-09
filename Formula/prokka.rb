class Prokka < Formula
  # cite Seemann_2014: "https://doi.org/10.1093/bioinformatics/btu153"
  desc "Rapid annotation of prokaryotic genomes"
  homepage "https://github.com/tseemann/prokka"
  url "https://github.com/tseemann/prokka/archive/v1.14.0.tar.gz"
  sha256 "70b647c3efc296fc2909ba85056aa88e76832917876ff22e723798dcab281bb5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9d5256b21befdf947eaab88562dcd933e34094facca2536987b9beabfa982c1d" => :sierra
    sha256 "02017daea749350775e1773e4632f6096dd98929b812f07e7213d89b5d0dcb6e" => :x86_64_linux
  end

  depends_on "aragorn"
  depends_on "barrnap"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "infernal"
  depends_on "minced"
  depends_on "parallel"
  depends_on "prodigal"
  depends_on "tbl2asn"
  unless OS.mac?
    depends_on "less"
    depends_on "perl"
  end

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
