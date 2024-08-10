class Quast < Formula
  # cite Gurevich_2013: "https://doi.org/10.1093/bioinformatics/btt086"
  # cite Mikheenko_2015: "https://doi.org/10.1093/bioinformatics/btv697"
  # cite Mikheenko_2016: "https://doi.org/10.1093/bioinformatics/btw379"
  # cite Mikheenko_2018: "https://doi.org/10.1093/bioinformatics/bty266"
  include Language::Python::Virtualenv
  desc "Quality Assessment Tool for Genome Assemblies"
  homepage "https://quast.sourceforge.io/"
  url "https://github.com/ablab/quast/archive/refs/tags/quast_5.2.0.tar.gz"
  sha256 "db903a6e4dd81384687f1c38d47cbe0f51bdf7f6d5e5c0bd30c13796391f4f04"
  head "https://github.com/ablab/quast.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "96cbef2a8207cb7e5335482f745ef619ceca992729d3ad853495bb2e396700d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a091a5df4a4895c1c3de153adaeb27473d72c6693855214bc648a9f3a3bff59"
  end

  depends_on "pkg-config" => :build
  depends_on "brewsci/bio/barrnap"
  depends_on "brewsci/bio/glimmerhmm"
  depends_on "bwa"
  depends_on "minimap2"
  depends_on "openjdk@11"
  depends_on "python-matplotlib"
  depends_on "python@3.12"
  depends_on "sambamba"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  def python3
    which("python3.12")
  end

  def install
    # Remove bundled non-native binaries
    rm_r ["quast_libs/barrnap", "quast_libs/genemark", "quast_libs/genemark-es",
          "quast_libs/sambamba", "quast_libs/site_packages/simplejson"]
    # Use Homebrew's sambamba binaries
    inreplace "quast_libs/ra_utils/misc.py" do |s|
      s.gsub! "platform_suffix = '_osx' if qconfig.platform_name == 'macosx' else '_linux'", ""
      s.gsub! "return join(sambamba_dirpath, fname + platform_suffix)",
              "return get_path_to_program(fname, sambamba_dirpath)"
      s.gsub! "from distutils.dir_util import copy_tree", "from setuptools import copy_tree"
    end
    # To be compatible with python 3.12
    inreplace "quast_libs/qconfig.py", "from distutils.version import LooseVersion",
                                       "from packaging.version import Version as LooseVersion"
    # Use Homebrew's barrnap
    inreplace "quast_libs/run_barrnap.py",
              "barrnap_fpath = join(qconfig.LIBS_LOCATION, 'barrnap', 'bin', 'barrnap')",
              "barrnap_fpath = \"#{Formula["brewsci/bio/barrnap"].opt_bin}/barrnap\""
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath
    # install *.py scripts
    bin.install Dir[libexec/"bin/*.py"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME:  Formula["openjdk@11"].opt_prefix,
                                            PYTHONPATH: ENV["PYTHONPATH"])
    prefix.install "test_data"
  end

  test do
    cp_r "#{prefix}/test_data", testpath
    system "#{bin}/quast.py", "#{testpath}/test_data/contigs_1.fasta",
           "#{testpath}/test_data/contigs_2.fasta",
           "-r", "#{testpath}/test_data/reference.fasta.gz",
           "-g", "#{testpath}/test_data/genes.txt",
           "-1", "#{testpath}/test_data/reads1.fastq.gz",
           "-2", "#{testpath}/test_data/reads2.fastq.gz",
           "-o", "output", "-t", "1", "--debug", "--glimmer"
    assert_predicate testpath/"output/report.pdf", :exist?
  end
end
