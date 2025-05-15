class Qmean < Formula
  include Language::Python::Virtualenv

  # cite Benkert_2011: "https://doi.org/10.1093/bioinformatics/btq662"
  # cite Studer_2014: "https://doi.org/10.1093/bioinformatics/btu457"
  # cite Studer_2020: "https://doi.org/10.1093/bioinformatics/btz828"

  desc "Qualitative Model Energy ANalysis (QMEAN)"
  homepage "https://git.scicore.unibas.ch/schwede/QMEAN"
  url "https://git.scicore.unibas.ch/schwede/QMEAN/-/archive/4.3.1/qmean-4.3.1.tar.gz"
  sha256 "01a8b89e41bde00c35ae19d263bbd53df5591319281c0a5f6654a989e56a2ee4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "a84eec553e42deac958e044af1ddafc441d0966aeb66eae3d5d3a57e46f00ff3"
    sha256 cellar: :any,                 arm64_sonoma:  "943d057623dad843a54b63f5baa6210031e15d43ea92ef8a92c2e1a909ac349d"
    sha256 cellar: :any,                 ventura:       "37fcb2aa4b3300cd9f9e4d5124c3c6442221fc477aca84a4be14bf6c2ad6f642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dd75ce4b8842f3976d2965fef3a5a16a68567251d288cb64f96467e43e76b66"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "meson" => :build # for building numpy
  depends_on "ninja" => :build # for building numpy
  depends_on "python-setuptools" => :build # for building numpy
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/hh-suite"
  depends_on "brewsci/bio/openstructure"
  depends_on "openblas" # for numpy
  depends_on "python-matplotlib"
  depends_on "python@3.13"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build # for building numpy
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  patch do
    # Patch for Homebrew packaging (make src compatibile with boost@1.88 and fix qmean version display)
    url "https://raw.githubusercontent.com/eunos-1128/QMEAN/b972afca2842df673be49355669f68d54b965110/homebrew.patch"
    sha256 "19f114b8f84d73a61b5453418057b39e590676ce57489a787eb5eba323075a93"
  end

  def python3
    "python3.13"
  end

  def install
    if OS.mac?
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"
    elsif OS.linux?
      ENV.prepend "LDFLAGS", "-Wl,--allow-shlib-undefined,--export-dynamic -lstdc++"
    end

    # Install python packages using virtualenv pip
    venv = virtualenv_create libexec, which(python3)
    ENV.prepend_path "PATH", libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", venv.site_packages
    site_packages_path = Language::Python.site_packages python3
    (prefix/site_packages_path/"homebrew-qmean.pth").write venv.site_packages
    venv.pip_install resources

    inreplace "CMakeLists.txt", "lib64", "lib"
    inreplace "CMakeLists.txt", "find_package(Python 3.6", "find_package(Python 3"
    inreplace "cmake_support/QMEAN2.cmake", "${Python_LIBRARIES}", ""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *%W[
        -DCMAKE_CXX_STANDARD=11
        -DPython_ROOT_DIR=#{Formula["python@3.13"].opt_prefix}
        -DOST_ROOT=#{Formula["openstructure"].opt_prefix}
        -DOPTIMIZE=ON
      ]

      system "make"
      system "make", "install"
    end

    Dir.chdir "doc" do
      system "make", "html"
      doc.install Dir["*"]
    end

    pkgshare.install "docker"
    cp pkgshare/"docker/run_qmean.py", pkgshare/"docker/run_qmean_copy.py"
    bin.install pkgshare/"docker/run_qmean_copy.py" => "qmean"
    inreplace bin/"qmean", "#!/usr/local/bin/ost", "#!/usr/bin/env ost"
    inreplace bin/"qmean", "/usr/local", Formula["hh-suite"].opt_prefix
    inreplace bin/"qmean", '"/uniclust30"', 'os.getenv("QMEAN_UNICLUST30")'
    inreplace bin/"qmean",
      'raise RuntimeError("You must mount UniClust30 to /uniclust30")',
      'raise RuntimeError(f"You must set UniClust30 to {os.getenv("QMEAN_UNICLUST30")}")'
    inreplace bin/"qmean",
      '"Expect valid UniClust30 to be mounted at /uniclust30. Files "',
      'f"Expect valid UniClust30 to be mounted at {os.getenv("QMEAN_UNICLUST30")}. Files "'
    inreplace bin/"qmean",
      "# uniclust30 is expected to be mounted at /uniclust30",
      "# uniclust30 is expected to be mounted at `QMEAN_UNICLUST30`"
    inreplace bin/"qmean", '"QMEAN container entry point running\n"', ""
    inreplace bin/"qmean",
      "os.getenv('VERSION_QMEAN')",
      "\"#{version}\""
    inreplace bin/"qmean",
      "os.getenv('VERSION_OPENSTRUCTURE')",
      "\"#{Formula["openstructure"].version}\""
    inreplace bin/"qmean", '"/qmtl/VERSION"', 'f"/{os.getenv("QMEAN_QMTL")}/VERSION"'
    inreplace bin/"qmean", '"/qmtl"', 'os.getenv("QMEAN_QMTL")'
    inreplace bin/"qmean", "/qmtl", "`QMEAN_QMTL`"

    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      QMEAN provides three analysis modes: QMEAN, QMEANDisCo, and QMEANBrane.
      All modes require the UniClust30 database, while QMEANDisCo additionally
      requires the QMEAN Template Library (QMTL) for its scoring.

      1) UniClust30 database (required by QMEAN, QMEANDisCo, QMEANBrane)
         ───────────────────────────────────────────────────────────────────────
         You must set the QMEAN_UNICLUST30 environment variable to point to
         your local UniClust30 database directory, which must contain:
           • *_a3m.ffdata
           • *_a3m.ffindex
           • *_hhm.ffdata
           • *_hhm.ffindex
           • *_cs219.ffdata
           • *_cs219.ffindex

         Example (add to ~/.bashrc or ~/.zshrc):
           export QMEAN_UNICLUST30=/path/to/uniclust30/uniclust30_2018_08

         Download UniClust30 from:
           https://uniclust.mmseqs.com/

      2) QMEAN Template Library (QMTL) (required only by QMEANDisCo)
         ───────────────────────────────────────────────────────────────────────
         QMTL provides the model/template files needed for DisCo scoring.

         You can download to extract the archive manually from:
           https://swissmodel.expasy.org/repository/download/qmtl/qmtl.tar.bz2

         Example (add to ~/.bashrc or ~/.zshrc):
           `export QMEAN_QMTL=#{opt_pkgshare}/qmtl`

      Without these environment variables, `qmean` will exit with an error
      indicating which resource is missing.
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/qmean -h 2>&1")
    system libexec/"bin/python3", doc/"source/example_scripts/local_scorer_example.py"
  end
end
