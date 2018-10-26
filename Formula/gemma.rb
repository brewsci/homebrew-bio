class Gemma < Formula
  # cite Zhou_2012: "http://dx.doi.org/10.1038/ng.2310"
  desc "Linear mixed models (LMMs) for genome-wide association (GWA)"
  homepage "https://github.com/genetics-statistics/gemma"
  url "https://github.com/genetics-statistics/GEMMA/archive/v0.98.tar.gz"
  sha256 "ab00d933007ce375c3c187486a7ded4c5e45b711f30ee3434821310b416889de"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "a70496a8b7dcb1b2b0466f32729a2087d43e511de00e619b52090ed9d745c5b9" => :sierra
    sha256 "78f2bcec7d7f010188a5619d83b3b68a6b4169c8e40ae33fd1e03815bc98facb" => :x86_64_linux
  end

  depends_on "eigen" => :build

  depends_on "gsl"
  depends_on "openblas"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

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
