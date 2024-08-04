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
    sha256 cellar: :any, catalina:     "23046c62a90ea7b0eca403f3785270a19044ee2df642edbfbe1c85d1e5b7f8d6"
    sha256 cellar: :any, x86_64_linux: "f9f148edfccb1d956cc02dcf055fec2cbb1725e7b2fe86d99f1f861fe734e5bb"
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
