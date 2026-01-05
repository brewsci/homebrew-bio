class Btllib < Formula
  # cite Nikolić_2022: "https://doi.org/10.21105/joss.04720"
  include Language::Python::Virtualenv

  desc "Bioinformatics Technology Lab common code library in C++ with Python wrappers"
  homepage "https://bcgsc.github.io/btllib/"
  url "https://github.com/bcgsc/btllib.git",
      tag:      "v1.7.3",
      revision: "1a7c07a3f0b49d1b06feccb97c40625633b53bc3"
  license "GPL-3.0-or-later"
  head "https://github.com/bcgsc/btllib.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "76d3094e97e95b10cd6bfcd9272bcd957856a60e6f378e53cca6537315bfa604"
    sha256 cellar: :any,                 ventura:      "cafbdd7cc1de9361943dcac28f42fdf1bfd1811356745b76604817b7c20f567c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4e09b734fc392306e9df9d9451d83f478507acf0eccc722f9a34fccc1c0fbde"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "swig" => :build
  depends_on "gcovr"
  depends_on "samtools"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def python3
    "python3.12"
  end

  def install
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
