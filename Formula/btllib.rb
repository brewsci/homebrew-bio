class Btllib < Formula
  # cite Nikolić_2022: "https://doi.org/10.21105/joss.04720"
  desc "Bioinformatics Technology Lab common code library in C++ with Python wrappers"
  homepage "https://bcgsc.github.io/btllib/"
  url "https://github.com/bcgsc/btllib/releases/download/v1.6.2/btllib-1.6.2.tar.gz"
  sha256 "06af0bccd68443bc6351d1d6d46599ae2a6e94752ae5fdf973067a77740d751c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 monterey:     "3b74945052ebe8f26c124317889c7e6ea9fbf5961e92f0c0325dbe37e427ab38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1179e283868e96842b722025c5ceccc03396df65fad09691a7de49267e3c8daf"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "swig" => :build
  depends_on "gcovr"
  depends_on "samtools"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    ENV.cxx11

    if OS.mac?
      libomp = Formula["libomp"]
      ENV.append "CXXFLAGS", "-Xpreprocessor -fopenmp -I#{libomp.opt_include} -L#{libomp.opt_lib} -lomp"
    end

    system "./compile", "--prefix=#{prefix}"

    rm_r Dir["#{lib}/btllib/python/btllib/__pycache__"]
    cd "#{lib}/btllib/python" do
      system python3, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system "#{bin}/indexlr", "--help"
    system python3, "-c", "import btllib"
  end
end
