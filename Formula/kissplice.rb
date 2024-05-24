class Kissplice < Formula
  # cite Sacomoto_2012: https://doi.org/10.1186/1471-2105-13-S6-S5
  desc "Local transcriptome assembler for SNPs, indels and AS events"
  homepage "https://kissplice.prabi.fr"
  url "https://gitlab.inria.fr/erable/kissplice.git",
      tag:      "2.6.5",
      revision: "00cb99c3b1971866089ef0439526647d328115d0"
  license "CECILL-2.0"

  depends_on "cmake" => :build
  depends_on "python@3.12" # Python application but only uses standard packages

  uses_from_macos "zlib"

  def install
    # Fix the content of 2 template files in bcalm that store the compiler path.
    # The bcalm git is created by cmake ExternalProject step, clear during PATCH_COMMAND.
    (buildpath/"empty_settings_file").write "Removed but must be non-empty"
    (buildpath/"fixed_buildinfo_header").write <<-EOF
      #define STR_LIBRARY_VERSION     "${gatb-core-version}"
      #define STR_COMPILATION_DATE    "${gatb-core-date}"
      #define STR_COMPILATION_FLAGS   "${gatb-core-flags}"
      #define STR_COMPILER            "c compiler  (${CMAKE_CXX_COMPILER_VERSION})"
      #define STR_OPERATING_SYSTEM    "${CMAKE_SYSTEM}"
    EOF
    inreplace "CMakeLists.txt", "# This is run inside bcalm build dir.", <<-EOF
      PATCH_COMMAND "${CMAKE_COMMAND}" -E copy #{buildpath}/empty_settings_file
        gatb-core/gatb-core/thirdparty/hdf5/config/cmake/libhdf5.settings.cmake.in
        && "${CMAKE_COMMAND}" -E copy #{buildpath}/fixed_buildinfo_header
        gatb-core/gatb-core/src/gatb/system/api/build_info.hpp.in
    EOF

    system "cmake", "-S", ".", "-B", "build/", "-DUSE_BUNDLED_BCALM=ON", *std_cmake_args
    system "cmake", "--build", "build/"
    system "cmake", "--install", "build/"
  end

  test do
    resource "git" do
      url "https://gitlab.inria.fr/erable/kissplice.git",
          tag:      "2.6.5",
          revision: "00cb99c3b1971866089ef0439526647d328115d0"
    end

    resource("git").stage do
      # Run sample example from the git data
      system "#{bin}/kissplice",
        "-r", "sample_example/mock1.fq", "-r", "sample_example/mock2.fq",
        "-r", "sample_example/virus1.fq", "-r", "sample_example/virus2.fq"
    end
  end
end
