class Gemma < Formula
  # cite Zhou_2012: "http://dx.doi.org/10.1038/ng.2310"
  desc "Linear mixed models (LMMs) for genome-wide association (GWA)"
  homepage "https://github.com/genetics-statistics/gemma"
  url "https://github.com/genetics-statistics/GEMMA/archive/0.98.1.tar.gz"
  sha256 "6beeed4a9e727a96fdea9e86e39bbe9cbc9f0540ad3a1053814e95b0863a7e6b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "552f7f77c75747d9d0457706cb480fed17063f633d088e099ef3aac44b4aea4f" => :sierra
    sha256 "4a65d64d34e24e2ac644bd9ad4eca53adca4c395d6fee82a3d78d4e3a1052247" => :x86_64_linux
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
