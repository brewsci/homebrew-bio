class Maker < Formula
  # cite Cantarel_2007: "https://doi.org/10.1101/gr.6743907" # MAKER
  # cite Holt_2011: "https://doi.org/10.1186/1471-2105-12-491" # MAKER2
  # cite Campbell_2013: "https://doi.org/10.1104/pp.113.230144" # MAKER-P
  desc "Genome annotation pipeline"
  homepage "https://www.yandell-lab.org/software/maker.html"
  url "http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-2.31.9.tgz"
  sha256 "c92f9c8c96c6e7528d0a119224f57cf5e74fadfc5fce5f4b711d0778995cabab"
  revision 2

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c6cc8d7e23cae66426580681b726c6653a60f07fe654d6e6a3fcc8a8de2d7399" => :sierra_or_later
    sha256 "d8219353cc1d7c8b339ccdcad812fbac80d1ae201ae0536244025a399eb9d9e9" => :x86_64_linux
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
