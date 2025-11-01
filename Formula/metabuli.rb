class Metabuli < Formula
  # cite Kim_2024: "https://doi.org/10.1038/s41592-024-02273-y""
  desc "Specific and sensitive metagenomic classification"
  homepage "https://github.com/steineggerlab/Metabuli"
  url "https://github.com/steineggerlab/Metabuli/archive/refs/tags/1.1.1.tar.gz"
  sha256 "62c2c8da10010b03ab5c5a353407b9ae12b8fe34aa5e5a648ae17383d7609192"
  license "GPL-3.0-or-later"
  head "https://github.com/steineggerlab/Metabuli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c90a4a08bbe41ab10f90687653696d25c0191fa0fe83856b155803b534dd4fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308156dde074a59c63186834fcf1cd9fde16fcf69352abd67773ddb0f7365f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28420dba98c116c5dcec101dc931268aa70f849901e989678927a767e7b9709e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd50565a4ec9ab27a935c39408eea1df467b6ff248ddfc3a6cdd0c868c88021f"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "mmseqs" do
    url "https://github.com/jaebeom-kim/MMseqs2/archive/62f8d3e17b429825695273e347775871339cda75.tar.gz"
    sha256 "67ff092e076e73772e03b79a8d980a370aaa097b7a1bec6a47718e43ba27f948"
  end

  resource "fasta_validator" do
    url "https://github.com/jaebeom-kim/fasta_validator/archive/ab9c05b81fc28c210dff5319e110b6aa8b81afa7.tar.gz"
    sha256 "67eac23d52d1f156a462f54b47b0e3f7a1500907a49c9e466f97f532143f40f4"
  end

  def install
    inreplace "CMakeLists.txt", "CMP0060 OLD", "CMP0060 NEW"
    (buildpath/"lib/mmseqs").install resource("mmseqs")
    (buildpath/"lib/fasta_validator").install resource("fasta_validator")
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
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
    pkgshare.install "data"
  end

  test do
    assert_match "metabuli Version", shell_output("#{bin}/metabuli --help")
  end
end
