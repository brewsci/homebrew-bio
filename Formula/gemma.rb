class Gemma < Formula
  # cite Zhou_2012: "http://dx.doi.org/10.1038/ng.2310"
  desc "Linear mixed models (LMMs) for genome-wide association (GWA)"
  homepage "https://github.com/genetics-statistics/gemma"
  url "https://github.com/genetics-statistics/GEMMA/archive/v0.98.4.tar.gz"
  sha256 "4f57a045d3289afaf31f818bf411ac46c5ee6f78ff8c9c4117963ca54e0bb9f0"
  license "GPL-3.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any,                 catalina:     "7e27d603f4afdd48b01b7db2e3fc2a7d401450932585652047a79f0875b0a50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70df4511ba6de74ebb2f0f6efcd6d02b48d7797a27c36dec95afd05574e7ee44"
  end

  depends_on "eigen" => :build
  depends_on "gsl"
  depends_on "openblas"

  uses_from_macos "zlib"

  def install
    # https://github.com/brewsci/homebrew-bio/pull/479
    inreplace "Makefile", "-lgfortran", ""
    inreplace "Makefile", "-lquadmath", ""

    system "make", "EIGEN_INCLUDE_PATH=#{Formula["eigen"].opt_include}/eigen3",
                   "OPENBLAS_INCLUDE_PATH=#{Formula["openblas"].opt_include}",
                   "DEBUG="
    bin.install "bin/gemma"
    doc.install Dir["doc/*"]
    pkgshare.install "example", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemma -licence 2>&1")
  end
end
