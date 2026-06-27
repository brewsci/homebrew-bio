class Expansionhunterdenovo < Formula
  desc "Detect novel expansions of short tandem repeats (STRs)"
  homepage "https://github.com/Illumina/ExpansionHunterDenovo"
  url "https://github.com/Illumina/ExpansionHunterDenovo/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2cddd07a2b2a6a438d1b1cb756b2b6fc8d76a0213699e035db72f265f98a6b44"
  license "Apache-2.0"
  head "https://github.com/Illumina/ExpansionHunterDenovo.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "htslib"

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    cd "source" do
      # The upstream CMake bundles Boost via boost-cmake, which tries to
      # download the Boost source archive from a dead bintray URL, and rebuilds
      # htslib from a vendored tarball. Neither works in the Homebrew sandbox,
      # so build against Homebrew's Boost and htslib instead. Also bump the
      # language standard to C++17 (required by modern toolchains) and drop the
      # UnitTests target, which depends on a vendored test framework.
      inreplace "CMakeLists.txt" do |s|
        s.gsub! "set(CMAKE_CXX_STANDARD 11)", "set(CMAKE_CXX_STANDARD 17)"
        s.gsub! "add_subdirectory(thirdparty/boost-cmake-1.67.0)",
                "find_package(Boost REQUIRED COMPONENTS program_options filesystem)"
        s.gsub! "Boost::system Boost::program_options", "Boost::program_options"
        # Remove the UnitTests executable (everything from its definition on).
        s.sub!(/add_executable\(UnitTests.*\z/m, "")
      end

      # Replace the htslib ExternalProject (rebuilds htslib from a vendored
      # tarball) with Homebrew's htslib as an imported shared library.
      hts_lib = formula_opt_lib("htslib")
      hts_include = formula_opt_include("htslib")
      File.write "io/CMakeLists.txt", <<~CMAKE
        find_package(Threads)

        include(FindZLIB)
        include(FindBZip2)
        include(FindLibLZMA)

        add_library(htslib SHARED IMPORTED)
        set_property(TARGET htslib PROPERTY IMPORTED_LOCATION #{hts_lib}/libhts.dylib)

        add_library(io STATIC
                HtsFileStreamer.hh HtsFileStreamer.cpp
                HtsHelpers.hh HtsHelpers.cpp
                Reference.hh Reference.cpp)

        target_include_directories(io PUBLIC
                ${CMAKE_SOURCE_DIR}
                #{hts_include}
                )

        target_link_libraries(io PUBLIC
                reads
                htslib
                ${ZLIB_LIBRARIES}
                ${LIBLZMA_LIBRARIES}
                ${BZIP2_LIBRARIES}
                ${CMAKE_THREAD_LIBS_INIT}
                )
      CMAKE

      # On Linux htslib installs a .so rather than a .dylib.
      inreplace "io/CMakeLists.txt", "/libhts.dylib", "/libhts.so" unless OS.mac?

      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/ExpansionHunterDenovo"
    end

    # Downstream Python analysis helpers (case-control and outlier tests).
    # They require numpy/scipy that Homebrew does not manage here, so they are
    # provided for reference rather than linked onto the PATH.
    libexec.install Dir["scripts/*"]
  end

  test do
    help_output = shell_output("#{bin}/ExpansionHunterDenovo --help 2>&1")
    assert_match "ExpansionHunter Denovo v#{version}", help_output
    assert_match "Compute genome-wide STR profile", help_output
    profile_output = shell_output("#{bin}/ExpansionHunterDenovo profile --help 2>&1")
    assert_match "--reference", profile_output
  end
end
