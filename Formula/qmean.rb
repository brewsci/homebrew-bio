class Qmean < Formula
  # cite
  # cite
  # cite
  desc "Qualitative Model Energy ANalysis (QMEAN)"
  homepage "https://git.scicore.unibas.ch/schwede/QMEAN"
  url "https://git.scicore.unibas.ch/schwede/QMEAN/-/archive/4.3.1/qmean-4.3.1.tar.gz"
  sha256 "01a8b89e41bde00c35ae19d263bbd53df5591319281c0a5f6654a989e56a2ee4"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/hh-suite"
  depends_on "brewsci/bio/openstructure"
  depends_on "numpy"
  depends_on "python-matplotlib"
  depends_on "python@3.13"
  depends_on "scipy"

  patch do
    # Patch for Homebrew packaging (make src compatibile with boost@1.88 and fix qmean version display)
    url "https://raw.githubusercontent.com/eunos-1128/QMEAN/b972afca2842df673be49355669f68d54b965110/homebrew.patch"
    sha256 "19f114b8f84d73a61b5453418057b39e590676ce57489a787eb5eba323075a93"
  end

  def install
    if OS.mac?
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"
    elsif OS.linux?
      ENV.prepend "LDFLAGS", "-Wl,--allow-shlib-undefined,--export-dynamic -lstdc++"
    end

    inreplace "CMakeLists.txt", "lib64", "lib"
    inreplace "CMakeLists.txt", "find_package(Python 3.6", "find_package(Python 3"
    inreplace "cmake_support/QMEAN2.cmake", "${Python_LIBRARIES}", ""

    mkdir "build" do
      system "cmake", "..",
        *std_cmake_args,
        "-DOPTIMIZE=ON",
        "-DOST_ROOT=#{Formula["openstructure"].opt_prefix}"

      system "make"
      # system "make", "check"
      system "make", "install"
    end

    Dir.chdir "doc" do
      system "make", "html"
      doc.install Dir["build/html/*"]
    end

    pkgshare.install "docker"
    bin.install pkgshare/"docker/run_qmean.py" => "qmean"
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
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      Command `qmean` needs access to the UniClust30 database to run properly.

      You must set the `QMEAN_UNICLUST30` environment variable to point to
      your UniClust30 database directory, which must contain the following files:
        - *_a3m.ffdata
        - *_a3m.ffindex
        - *_hhm.ffdata
        - *_hhm.ffindex
        - *_cs219.ffdata
        - *_cs219.ffindex

      For example in your ~/.bashrc or ~/.zshrc:
        `export QMEAN_UNICLUST30=/path/to/uniclust30/uniclust30_2018_08`

      Without this setting, `qmean` will fail with an error like:
      "You must set UniClust30 to {QMEAN_UNICLUST30}"

      The UniClust30 database can be downloaded from:
      https://uniclust.mmseqs.com/
    EOS
  end

  test do
    assert_match "usage:", shell_output("#{bin}/qmean -h 2>&1")
  end
end
