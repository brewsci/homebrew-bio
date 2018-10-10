class Gemma < Formula
  # cite Zhou_2012: "http://dx.doi.org/10.1038/ng.2310"
  desc "Linear mixed models (LMMs) for genome-wide association (GWA)"
  homepage "https://github.com/genetics-statistics/gemma"
  url "https://github.com/genetics-statistics/gemma.git" # , :revision => "595197546e1418b4944e2f797d8ceac6d495f741"
  version "0.98"

  depends_on "eigen" => :build
  depends_on "gsl"
  # include openblas because of cblas.h
  depends_on "openblas"
  depends_on "zlib" unless OS.mac?

  def install
    system "make", "EIGEN_INCLUDE_PATH=#{Formula["eigen"].opt_include}/eigen3"
    bin.install "bin/gemma"
  end

  test do
    assert_match "GEMMA", shell_output("#{bin}/gemma 2>&1")
  end
end
