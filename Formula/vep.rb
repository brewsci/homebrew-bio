class Vep < Formula
  # cite McLaren_2016: "https://doi.org/10.1186/s13059-016-0974-4"
  desc "Ensembl Variant Effect Predictor (VEP)"
  homepage "https://www.ensembl.org/info/docs/tools/vep/index.html"
  url "https://github.com/Ensembl/ensembl-vep/archive/refs/tags/release/116.0.tar.gz"
  sha256 "618a4b6d37efbe0968d7ad1115bf6b712f8537c4697659be6c41580708eb5167"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/Ensembl/ensembl-vep.git"
    strategy :git
    regex(%r{^release/(\d+(?:\.\d+)+)$}i)
  end

  depends_on "cpanminus" => :build
  depends_on "htslib"
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "zlib-ng-compat" # linked (libz) by the XS deps via htslib/mysql-client
  depends_on "zstd"

  # The Ensembl Perl API, pinned to the release/116 branch HEAD commits. VEP
  # cannot be used without it; INSTALL.pl normally clones these at runtime.
  resource "ensembl" do
    url "https://github.com/Ensembl/ensembl/archive/0d852313c420a1d5128b6774635125ebbac03350.tar.gz"
    sha256 "a49b7bed6aca87546ad0ee7ea83e0f30c88465c51b230cf482f2d40bc22bad82"
  end
  resource "ensembl-variation" do
    url "https://github.com/Ensembl/ensembl-variation/archive/2fb834b987ede3824e200197a838ce11e91aeb4b.tar.gz"
    sha256 "237fca32e9ddb30632717813f34251b8ed29e2de15c39ed21d3dca49a1193f2e"
  end
  resource "ensembl-funcgen" do
    url "https://github.com/Ensembl/ensembl-funcgen/archive/90049ea7ee4d8ae3a6d298dca46d6c6ab20538c4.tar.gz"
    sha256 "aac8132f013bbd2d09b03f9af6131a2fb1c7db174dfd40397a56a05acae80d14"
  end
  resource "ensembl-io" do
    url "https://github.com/Ensembl/ensembl-io/archive/6afb5dc27a5ae6881d75959153fbe6e9a4a7e788.tar.gz"
    sha256 "45154809117aff507b91df86fe5fd74a4df0bcf3b588f0b0d0f6ea5278ee28cc"
  end

  # BioPerl version frozen by the Ensembl API (pure-Perl, just staged).
  resource "bioperl" do
    url "https://github.com/bioperl/bioperl-live/archive/refs/tags/release-1-6-924.tar.gz"
    sha256 "547a65a1c083bd40345514893cf91491d49318f2290dd8d0a539b742327cbe25"
  end

  def install
    vendor = libexec/"vendor"
    perl = formula_opt_bin("perl")/"perl"
    archname = Utils.safe_popen_read(perl, "-MConfig", "-e", "print $Config{archname}").strip

    # Help the XS bindings find their C libraries: Bio::DB::HTS -> htslib,
    # DBD::mysql -> mysql-client (which links zstd + openssl).
    ENV["HTSLIB_DIR"] = formula_opt_prefix("htslib")
    ENV.prepend_path "PATH", formula_opt_bin("mysql-client")
    %w[zstd openssl@3 mysql-client].each { |f| ENV.prepend_path "LIBRARY_PATH", formula_opt_lib(f) }
    %w[zstd openssl@3].each { |f| ENV.prepend_path "CPATH", formula_opt_include(f) }

    # Stage BioPerl (the API's frozen version) into the vendor lib BEFORE cpanm,
    # so Bio::DB::HTS's `Bio::SeqFeature::Lite` dependency is already satisfied.
    # Otherwise cpanm pulls a fresh BioPerl whose XML::LibXML/DB_File deps fail
    # to build (notably on Linux).
    resource("bioperl").stage { (vendor/"lib/perl5").install "Bio" }

    # CPAN dependencies, including the two XS bindings (DBD::mysql for database
    # mode). Installed at build time, mirroring INSTALL.pl.
    system "cpanm", "--notest", "--local-lib=#{vendor}",
           "Bio::DB::HTS", "DBD::mysql", "DBI", "Set::IntervalTree",
           "JSON", "Text::CSV", "PerlIO::gzip", "Sereal", "Capture::Tiny", "Archive::Zip",
           "List::MoreUtils", "LWP::Simple"

    %w[ensembl ensembl-variation ensembl-funcgen ensembl-io].each do |r|
      resource(r).stage { (libexec/"api"/r).install "modules" }
    end

    libexec.install "vep", "filter_vep", "haplo", "variant_recoder", "INSTALL.pl", "modules"

    perl5lib = [
      vendor/"lib/perl5",
      vendor/"lib/perl5"/archname,
      libexec/"api/ensembl/modules",
      libexec/"api/ensembl-variation/modules",
      libexec/"api/ensembl-funcgen/modules",
      libexec/"api/ensembl-io/modules",
      libexec/"modules",
    ].join(":")
    env = {
      PERL5LIB: perl5lib,
      PATH:     "#{formula_opt_bin("htslib")}:#{formula_opt_bin("perl")}:$PATH",
    }
    %w[vep filter_vep haplo variant_recoder].each do |s|
      (bin/s).write_env_script libexec/s, env
    end
    # Expose the installer as `vep_install` for downloading cache/FASTA data.
    (bin/"vep_install").write_env_script libexec/"INSTALL.pl", env
  end

  def caveats
    <<~EOS
      VEP is installed with its Perl/API dependencies bundled, so no INSTALL.pl
      run is needed. Cache and FASTA data are not bundled (tens of GB); download
      them for your species, e.g.:
        vep_install -a cf -s homo_sapiens -y GRCh38 -c ~/.vep
      then run offline:
        vep --offline --cache --dir_cache ~/.vep -i input.vcf -o out.txt
    EOS
  end

  test do
    assert_match "Ensembl VEP", shell_output("#{bin}/vep --help 2>&1")
    assert_match "filter_vep", shell_output("#{bin}/filter_vep --help 2>&1")
  end
end
