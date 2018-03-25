class Prokka < Formula
  # cite Seemann_2014: "https://doi.org/10.1093/bioinformatics/btu153"
  desc "Rapid annotation of prokaryotic genomes"
  homepage "https://github.com/tseemann/prokka"
  url "https://github.com/tseemann/prokka/archive/v1.13.tar.gz"
  sha256 "0090acd6e3a8cb2d517fe0933c717c4f8271c60d0a493f7c4927504d77a8db4f"

  depends_on "cpanminus" => :build

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
    rm_r "perl5"
    # remove need to install XML::Simple for most cases
    inreplace "bin/prokka", "use XML::Simple;\n", ""
    inreplace "bin/prokka", 'msg("Running RNAmmer");', "require XML::Simple;"
    # patch in brewed bioperl path
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    inreplace "bin/prokka",
              "use FindBin;\n",
              "use FindBin;\nuse lib '#{bioperl}';\n"
    prefix.install Dir["*"]
  end

  def post_install
    system "#{bin}/prokka", "--setupdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prokka --version 2>&1")
    assert_match "Kingdoms:", shell_output("#{bin}/prokka --listdb 2>&1")
    system "#{bin}/prokka", "--cpus=2", "--prefix=prokka",
      "--outdir=#{testpath}/prokka", "#{prefix}/test/plasmid.fna"
    assert_predicate testpath/"prokka/prokka.gff", :exist?
  end
end
