class Ntcard < Formula
  # cite Mohamadi_2017: "https://doi.org/10.1093/bioinformatics/btw832"
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/releases/download/1.2.2/ntcard-1.2.2.tar.gz"
  sha256 "bace4e6da2eb8e59770d38957d1a916844071fb567696994c8605fd5f92b5eea"
  license "MIT"

  head "https://github.com/bcgsc/ntCard"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "a71e7ef21aaa1dc67992b4462453a8842f89e177026e5ece76cd7519b70dd462"
    sha256 cellar: :any,                 ventura:      "9d420e7c2e48c90aed2d618c8a9f6619647de5ad290f5e85b456365a2097bb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f88449ff54d3c8c1982c248df042c2f4e23c977f6b327c70c6ab0106313e3b1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "./autogen.sh"
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
    ]
    if OS.mac?
      args += [
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp -lz",
      ]
    end
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntcard --help 2>&1")
  end
end
