class Expansionhunter < Formula
  # cite Dolzhenko_2019: "https://doi.org/10.1093/bioinformatics/btz431"
  desc "Estimate repeat sizes genome-wide from short-read sequencing data"
  homepage "https://github.com/Illumina/ExpansionHunter"
  url "https://github.com/Illumina/ExpansionHunter/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "921d1f8be658f2bdd144150278210bb921d605af921816e94a7508c0b9b9dfff"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "googletest" => :build

  depends_on "abseil"
  depends_on "boost"
  depends_on "curl"
  depends_on "fmt"
  depends_on "htslib"
  depends_on "spdlog"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # The top-level CMakeLists.txt fetches every dependency over the network
    # via ExternalProject (some URLs are dead), so build the inner `ehunter`
    # project directly against the Homebrew-provided libraries instead.
    inner = buildpath/"ehunter"
    graphtools = inner/"thirdparty/graph-tools-master-f421f4c"

    # Modern Abseil requires C++17; the project pins C++11.
    inreplace inner/"CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)",
              "set(CMAKE_CXX_STANDARD 17)"
    inreplace graphtools/"CMakeLists.txt", "set(CMAKE_CXX_STANDARD 11)",
              "set(CMAKE_CXX_STANDARD 17)"

    # Boost dropped the header-only "system" component long ago; recent Boost
    # no longer ships a CMake config for it.
    inreplace inner/"CMakeLists.txt",
              "find_package(Boost 1.73 REQUIRED COMPONENTS program_options filesystem system)",
              "find_package(Boost 1.73 REQUIRED COMPONENTS program_options filesystem)"
    inreplace graphtools/"CMakeLists.txt",
              "find_package(Boost 1.5 COMPONENTS program_options filesystem system REQUIRED)",
              "find_package(Boost 1.5 COMPONENTS program_options filesystem REQUIRED)"

    # Drop -Werror (and -pedantic): modern Boost/spdlog/abseil/fmt and the
    # bundled nlohmann/json headers emit warnings that are not fatal here.
    inreplace inner/"CMakeLists.txt", "add_compile_options(-Wall -Werror -Wextra)",
              "add_compile_options(-Wall -Wextra)"
    inreplace graphtools/"CMakeLists.txt", " -Wall -Werror -pedantic ", " -Wall "

    # Prefer the shared htslib: the static archive does not pull in libdeflate.
    inreplace inner/"CMakeLists.txt",
              "find_library(htslib libhts.a)\nfind_library(htslib hts)",
              "find_library(htslib hts)"

    # C++17 brings std::make_unique into scope, making the `using boost::make_unique`
    # plus ADL on std arguments ambiguous; just use std::make_unique.
    %w[locus/LocusAnalyzer.cpp sample/HtsSeekingSampleAnalysis.cpp].each do |f|
      inreplace inner/f, "#include <boost/smart_ptr/make_unique.hpp>\n", ""
      inreplace inner/f, "using boost::make_unique;", "using std::make_unique;"
    end

    # fmt 9+ no longer formats types with operator<< implicitly; opt the two
    # logged types in via fmt::ostream_formatter.
    inreplace inner/"sample/HtsSeekingSampleAnalysis.cpp",
              "using std::vector;\n\nnamespace ehunter\n{",
              "using std::vector;\n\n" \
              "template <> struct fmt::formatter<ehunter::GenomicRegion> : fmt::ostream_formatter\n{\n};\n" \
              "template <> struct fmt::formatter<ehunter::ReadId> : fmt::ostream_formatter\n{\n};\n\n" \
              "namespace ehunter\n{"

    prefix_path = %w[boost spdlog fmt abseil googletest htslib xz curl]
                  .map { |f| formula_opt_prefix(f) }.join(";")

    args = %W[
      -DCMAKE_PREFIX_PATH=#{prefix_path}
      -DCMAKE_LIBRARY_PATH=#{formula_opt_lib("htslib")}
      -DCMAKE_CXX_FLAGS=-I#{formula_opt_include("htslib")}
      -DCMAKE_POLICY_DEFAULT_CMP0167=OLD
    ]

    system "cmake", "-S", "ehunter", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "ExpansionHunter"

    bin.install "build/ExpansionHunter"
    pkgshare.install "variant_catalog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ExpansionHunter --version 2>&1")
    assert_match "variant-catalog", shell_output("#{bin}/ExpansionHunter --help 2>&1")
    assert_path_exists pkgshare/"variant_catalog/grch38"
  end
end
