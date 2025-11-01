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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "75e2588b17eb85a8db7ab1b59c2aab66c156a8912644b98dbc648a03340f345c"
    sha256 cellar: :any_skip_relocation, ventura:      "1b110d073d1cccc55b67fc70024bf9e122080e06267c079bd41cd000cd4347c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93348547d2a71880d608e6f5d9ed0c57f31bf1baf7a056d5ae4cc5d517a65d97"
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
