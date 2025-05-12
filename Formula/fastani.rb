class Fastani < Formula
  # cite Jain_2017: "https://doi.org/10.1101/225342"
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/refs/tags/v1.34.tar.gz"
  sha256 "dc185cf29b9fa40cdcc2c83bb48150db46835e49b9b64a3dbff8bc4d0f631cb1"
  license "Apache-2.0"
  head "https://github.com/ParBLiSS/FastANI.git", branch: "master"

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
    args = %W[-DGSL_ROOT_DIR=#{Formula["gsl"].opt_prefix}]
    args << "-DOpenMP_CXX_FLAGS:STRING=-Xpreprocessor;-fopenmp;-I#{Formula["libomp"].opt_include}" if OS.mac?
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
