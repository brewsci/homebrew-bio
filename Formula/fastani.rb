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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4e9d242d0d1f7b2aa797c3b1a889b691d1e84e2deb3f8c7ba50f5dc2d121d759"
    sha256 cellar: :any,                 arm64_sonoma:  "2e06c8a2cb802b39c6d84999d06723cbf005ca3fa527e3320ddf40dccd383698"
    sha256 cellar: :any,                 ventura:       "a570676778c0ca5901dabb4c99e730d8da95011e2139da0f191690cf0fca55be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f969df9ca68999812d4b7577baf827d27e13000903a3c90ebe026a13c82ee4e5"
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
    assert_path_exists testpath/"out"
    assert_path_exists testpath/"out.matrix"
  end
end
