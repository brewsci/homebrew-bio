class Maker < Formula
  # cite Cantarel_2007: "https://doi.org/10.1101/gr.6743907" # MAKER
  # cite Holt_2011: "https://doi.org/10.1186/1471-2105-12-491" # MAKER2
  # cite Campbell_2013: "https://doi.org/10.1104/pp.113.230144" # MAKER-P
  desc "Genome annotation pipeline"
  homepage "https://www.yandell-lab.org/software/maker.html"
  url "http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-2.31.10.tgz"
  sha256 "d3979af9710d61754a3b53f6682d0e2052c6c3f36be6f2df2286d2587406f07d"
  revision 2

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fd228276674bd6da591c88e57833acbbda08240b86a8fbb70bb9c7b24adc574b" => :sierra
    sha256 "0ab95a55c2a80af83a89b44997b88fa26a5d20b8ab0cd8db8b1fc2589687b406" => :x86_64_linux
  end

  devel do
    url "http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-3.01.02-beta.tgz"
    sha256 "1b44a7d930f49de6cac10d2818c45c292a2a400cb873f443828582a40c4b6bb0"
  end

  depends_on "cpanminus" => :build
  depends_on "augustus"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "exonerate"
  depends_on "repeatmasker"
  depends_on "snap"
  unless OS.mac?
    depends_on "sqlite"
  end

  # Build MAKER with MPI support, but do not force the dependency on the user.
  if ENV["CIRCLECI"]
    depends_on "open-mpi" => :recommended
  else
    depends_on "open-mpi" => :optional
  end

  # Fix a bug fixed upstream in 3.01.02-beta.
  # Pass --minintron and --maxintron to Exonerate when aligning protein.
  patch :DATA if build.stable?

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    system "cpanm", "-l", prefix/"perl5",
      "IO::All", "Perl::Unsafe::Signals", "Want", "forks", "forks::shared"
    system "cpanm", "-l", prefix/"perl5", "Bit::Vector", "DBD::SQLite", "Inline::C" unless OS.mac?

    cd "src" do
      mpi = build.with?("open-mpi") ? "yes" : "no"
      system "(echo #{mpi}; yes '') |perl Build.PL"
      system "./Build", "install"
    end
    rm_r "src"
    libexec.install Dir["*"]
    %w[gff3_merge maker].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  def caveats; <<~EOS
    Optional compoments of MAKER that can be installed using brew:
      infernal
      mir-prefer
      snoscan
      trnascan

    Optional components of MAKER that are not available using brew:
      GeneMarkS and GeneMark-ES. Download from http://exon.biology.gatech.edu
      FGENESH 2.4 or higher. Purchase from http://www.softberry.com

    MAKER is available for academic use under either the Artistic
    License 2.0 developed by the Perl Foundation or the GNU General
    Public License developed by the Free Software Foundation.

    MAKER is not available for commercial use without a license. Those
    wishing to license MAKER for commercial use should contact Beth
    Drees at the University of Utah TCO to discuss your needs.
  EOS
  end

  test do
    system "#{bin}/maker", "--version"
  end
end

__END__
diff --git maker-2.31.9/lib/polisher/exonerate/protein.pm maker-3.01.02-beta/lib/polisher/exonerate/protein.pm
index e65c855..5c238a3 100755
--- maker-2.31.9/lib/polisher/exonerate/protein.pm
+++ maker-3.01.02-beta/lib/polisher/exonerate/protein.pm
@@ -98,7 +98,7 @@ sub runExonerate {
	if ($matrix) {
	    $command .= " --proteinsubmat $matrix";
	}
-	$command .= " --showcigar ";
+	$command .= " --minintron $min_intron --maxintron $max_intron --showcigar";
	$command .= " > $o_file";

         my $w = new Widget::exonerate::protein2genome();
