class Foldmason < Formula
  # cite van Gilchrist_2024: "https://doi.org/10.1101/2024.08.01.606130"
  desc "Multiple Protein Structure Alignment at Scale with FoldMason"
  homepage "https://github.com/steineggerlab/foldmason"
  url "https://github.com/steineggerlab/foldmason/archive/refs/tags/4-dd3c235.tar.gz"
  version "4-dd3c235"
  sha256 "f01c261d822f68a615ef43c56dbe4b7ffed57c3115bdfd0299a33680dfaae67d"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/foldmason.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41886703133efde270cd1b545c809ed59f8d3e8e491ae1e8c984f101f161f784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51b16669f5f58b8b7b74e1a8d233c43512784b5d829e5a12ba4d893e2b55d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd45db9da090279380dd9a37bb12f36860e835162e40ee3c0c962ae314a741c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1017a1f24c38430894bc8ba5d67bc9dfde30d896e3c03d96622da0d9a1b95af8"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace ["CMakeLists.txt", "lib/foldseek/CMakeLists.txt"], "CMP0060 OLD", "CMP0060 NEW"
    args = []
    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "regression"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/steineggerlab/foldmason/refs/heads/main/regression/data/d1b0ba_"
      sha256 "cd96ec505470b9f3e2318a380bd6a4ac723d9e8f301cc341060e38512124d3fa"
    end
    resource("homebrew-testdata").stage testpath/"example"
    system bin/"foldmason", "easy-search", "example/d1b0ba_", "example", "aln", "tmpFolder"
    assert_equal "d1b0ba_\td1b0ba_\t1.000\t142\t0\t0\t1\t142\t1\t142\t3.722E-28\t1274\n", File.read("aln")
  end
end
