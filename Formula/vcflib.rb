class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
      tag:      "v1.0.10",
      revision: "2ad261860807e66dbd9bcb07fee1af47b9930d70"
  license "MIT"
  head "https://github.com/ekg/vcflib.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "1cdb8390f4fd060d45bb8581cc6a92506e4d2ef1241f927edefd292050f5fe76"
    sha256 cellar: :any,                 ventura:      "1758ff3007bebf97b21ee593f0999c71d74c85bab1c4281a39c36384db8da6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "249c40de2a83598bb1e1a37d166cece1841a6bb8188d87b6ccd1df4b1573a775"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zig" => :build

  depends_on "brewsci/bio/wfa2-lib"
  depends_on "htslib"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Fix libvcflib install destination
    inreplace "CMakeLists.txt",
              "install(TARGETS vcflib ARCHIVE DESTINATION ${CMAKE_INSTALL_BINDIR})",
              "install(TARGETS vcflib ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})"
    inreplace "CMakeLists.txt",
              "include_directories($ENV{CMAKE_PREFIX_PATH}/include/wfa2lib)",
              "include_directories(#{Formula["wfa2-lib"].opt_include}/wfa2lib)"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DHTSLIB_LOCAL=False",
                    "-DZIG=OFF",
                    "-DOPENMP=ON",
                    "-DWFA_GITMODULE=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install Dir["scripts/*.R"]
    pkgshare.install Dir["scripts/*.r"]
    rm Dir["scripts/*.R"]
    rm Dir["scripts/*.r"]
    bin.install Dir["scripts/*"]

    mv prefix/"man", pkgshare
    prefix.install "examples", "samples"
  end

  def caveats
    <<~EOS
      The vcflib R scripts can be found in
      #{HOMEBREW_PREFIX}/share/vcflib/
    EOS
  end

  test do
    assert_match "genotype", shell_output("#{bin}/vcfallelicprimitives -h 2>&1")
    assert_match "biallelic snps:\t6", shell_output("#{bin}/vcfstats #{prefix}/samples/sample.vcf 2>&1")
    assert_match "chr\t0\t1\t.", shell_output("echo 'chr 1 . T' | #{bin}/vcf2bed.py")
    assert_match "genotypes", shell_output("#{bin}/vcfgtcompare.sh 2>&1")
    system "#{bin}/vcffirstheader < /dev/null"
  end
end
