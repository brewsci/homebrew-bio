class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/refs/tags/v1.34.tar.gz"
  sha256 "dc185cf29b9fa40cdcc2c83bb48150db46835e49b9b64a3dbff8bc4d0f631cb1"
  license "Apache-2.0"
  head "https://github.com/ParBLiSS/FastANI.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "8a87f5ac2d028d5ce7ca725d0bf997cc4b19088e0a484f4e7a8be244966cbfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca81474d0cfc36a53ba106540fce4d5f6bd033008089ade6579bdc03d2cb3285"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gsl"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # require C++11
    ENV.append "CXXFLAGS", "-std=c++11"
    # https://github.com/ParBLiSS/FastANI/issues/17 (macos clang opts for gcc)
    # inreplace "Makefile.in", "-mmacosx-version-min=10.7 -stdlib=libc++", "-v"
    args = %W[
      -DGSL_ROOT_DIR=#{Formula["gsl"].opt_prefix}
      -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/data", "scripts"
  end

  test do
    assert_match "fragment length", shell_output("#{bin}/fastANI --help 2>&1")
    system "#{bin}/fastANI",
           "-q", pkgshare/"data/Shigella_flexneri_2a_01.fna",
           "-r", pkgshare/"data/Escherichia_coli_str_K12_MG1655.fna",
           "-o", testpath/"out",
           "--matrix"
    assert_predicate testpath/"out", :exist?
    assert_predicate testpath/"out.matrix", :exist?
  end
end
