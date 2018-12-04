class Maker < Formula
  # cite Cantarel_2007: "https://doi.org/10.1101/gr.6743907" # MAKER
  # cite Holt_2011: "https://doi.org/10.1186/1471-2105-12-491" # MAKER2
  # cite Campbell_2013: "https://doi.org/10.1104/pp.113.230144" # MAKER-P
  desc "Genome annotation pipeline"
  homepage "https://www.yandell-lab.org/software/maker.html"
  url "http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-2.31.9.tgz"
  sha256 "c92f9c8c96c6e7528d0a119224f57cf5e74fadfc5fce5f4b711d0778995cabab"
  revision 3

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6386bda1e5bcb5dcdab2494172c8bb38589e08c261002776359ca2f78109b8aa" => :sierra
    sha256 "75f70f0b2879d6503d019a19ddba847f2a559c828cbf94479248ce1f94829cfa" => :x86_64_linux
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
    depends_on "perl"
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
