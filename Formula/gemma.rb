class Gemma < Formula
  desc "Linear mixed models (LMMs) for genome-wide association (GWA)"
  homepage "https://github.com/genetics-statistics/gemma"
  url "https://github.com/genetics-statistics/gemma.git" # , :revision => "595197546e1418b4944e2f797d8ceac6d495f741"
  version "0.98"

  depends_on "gsl"
  depends_on "eigen"
  depends_on "openblas" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  def install
    # system "make", "EIGEN_INCLUDE_PATH=../Cellar/eigen/3.3.5/include/eigen3"
    system "make", "EIGEN_INCLUDE_PATH=#{Formula["eigen"].opt_include}/eigen3"
    # system "make", "check"
    bin.install "bin/gemma"
  end

  test do
    assert_match "GEMMA", shell_output("#{bin}/gemma 2>&1")
  end
end
