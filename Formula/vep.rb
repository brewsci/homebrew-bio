class Vep < Formula
  # cite McLaren_2016: "https://doi.org/10.1186/s13059-016-0974-4"
  desc "Ensembl Variant Effect Predictor (VEP)"
  homepage "https://github.com/Ensembl/ensembl-vep"
  url "https://github.com/Ensembl/ensembl-vep/archive/refs/tags/release/116.0.tar.gz"
  sha256 "618a4b6d37efbe0968d7ad1115bf6b712f8537c4697659be6c41580708eb5167"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/Ensembl/ensembl-vep.git"
    strategy :git
    regex(%r{^release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f58da9c27abf0d29660bbc1c202631652f0249720ad767233c96bebe948ff08a"
    sha256 cellar: :any, arm64_sequoia: "8985141218ed44680439b157cb475f9233c4711b7c1898c852e730259b2f30c1"
    sha256 cellar: :any, arm64_sonoma:  "d6835322960147b8f005261d8cf30574b4ea6fc2cc55c98a07fb49df95a2fa00"
    sha256 cellar: :any, x86_64_linux:  "fb475972e62546ad4e88826306d52e4649855118f95b13ff8b28dfcf9586ef7e"
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
  resource "ensembl-compara" do
    url "https://github.com/Ensembl/ensembl-compara/archive/5ea78be5e7e8fc25615dd31612fd5d97dda9478e.tar.gz"
    sha256 "7af4c23dde23716de2bee7a04938fdee19b9dd22069927af88b9db7a914011fd"
  end

  # BioPerl version frozen by the Ensembl API (pure-Perl, just staged).
  resource "bioperl" do
    url "https://github.com/bioperl/bioperl-live/archive/refs/tags/release-1-6-924.tar.gz"
    sha256 "547a65a1c083bd40345514893cf91491d49318f2290dd8d0a539b742327cbe25"
  end

  # Official VEP plugins (Ensembl/VEP_plugins), pinned to release/116. These
  # are the .pm files `vep_install -a p` would otherwise fetch; the data files
  # some plugins need are not bundled.
  resource "vep-plugins" do
    url "https://github.com/Ensembl/VEP_plugins/archive/61f2dd41e74ea172bcc129e4e64400496b39d0d8.tar.gz"
    sha256 "c76ab6167ee1d26be9a58376214c6e5bb0aa674673ba563e21701b49c6a0500e"
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

    # The five Ensembl API modules VEP requires (ensembl, ensembl-variation,
    # ensembl-funcgen, ensembl-compara, ensembl-io), each pinned to a commit on
    # the release/116 branch. The commit is recorded so `vep` can report the
    # per-module version, exactly as INSTALL.pl does via `.version/<module>`.
    api_release = version.major.to_s
    api_modules = {
      "ensembl"           => "0d852313c420a1d5128b6774635125ebbac03350",
      "ensembl-variation" => "2fb834b987ede3824e200197a838ce11e91aeb4b",
      "ensembl-funcgen"   => "90049ea7ee4d8ae3a6d298dca46d6c6ab20538c4",
      "ensembl-compara"   => "5ea78be5e7e8fc25615dd31612fd5d97dda9478e",
      "ensembl-io"        => "6afb5dc27a5ae6881d75959153fbe6e9a4a7e788",
    }
    api_modules.each_key do |r|
      resource(r).stage { (libexec/"api"/r).install "modules" }
    end

    libexec.install "vep", "filter_vep", "haplo", "variant_recoder", "INSTALL.pl", "modules"

    # Version metadata read by Bio::EnsEMBL::VEP::Utils::get_version_data, so
    # `vep --help` lists the API module versions instead of only ensembl-vep.
    (libexec/".version").mkpath
    api_modules.each do |r, commit|
      (libexec/".version"/r).write "release #{api_release}\nsub #{commit}\n"
    end

    # Bundle the official VEP plugins so `--plugin <Name>` works out of the box
    # with `--dir_plugins`. Stage the .pm files (and the example config) only,
    # dropping the repo's docs/tooling.
    resource("vep-plugins").stage do
      (libexec/"Plugins").install Dir["*.pm"]
      (libexec/"Plugins").install "config" if File.directory?("config")
    end

    perl5lib = [
      vendor/"lib/perl5",
      vendor/"lib/perl5"/archname,
      libexec/"api/ensembl/modules",
      libexec/"api/ensembl-variation/modules",
      libexec/"api/ensembl-funcgen/modules",
      libexec/"api/ensembl-compara/modules",
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

      The official VEP plugins are bundled. Point VEP at them with:
        vep --dir_plugins #{opt_libexec}/Plugins --plugin <PluginName> ...
      Many plugins need extra data files you must download separately (see each
      plugin's header docs).
    EOS
  end

  test do
    help = shell_output("#{bin}/vep --help 2>&1")
    assert_match "Ensembl VEP", help
    # The bundled API modules must report their versions, not just ensembl-vep.
    assert_match(/^\s*ensembl\s+: #{version.major}\./, help)
    assert_match(/^\s*ensembl-compara\s+: #{version.major}\./, help)
    assert_match "filter_vep", shell_output("#{bin}/filter_vep --help 2>&1")
    # The bundled VEP plugins should be present for use with --dir_plugins.
    assert_path_exists libexec/"Plugins/AlphaMissense.pm"
  end
end
