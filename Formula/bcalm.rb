class Bcalm < Formula
  # cite Chikhi_2016: "https://doi.org/10.1093/bioinformatics/btw279"
  desc "De Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  url "https://github.com/GATB/bcalm.git",
      tag:      "v2.2.3",
      revision: "1f8a8b15e84f6bcaf47296eb3eb381288131b203"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "dcc1e682e002280de1aab1401b61c6c74921ea92e9e855325546c06e5da4c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9e93a21a9cddaf7647a8947539d6ebbfa93c904bba36498bb9f0bf1ccdcbd28"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # bcalm and its gatb-core submodule request an ancient CMake policy version
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # gatb-core and its bundled HDF5 bake the compiler path (Homebrew's shim
    # wrapper on Linux) into bin/bcalm via generated build banners, which trips
    # brew audit's check for references to the Homebrew shims directory. Drop
    # the compiler-path substitutions from the source templates so nothing
    # references the shim directory.
    inreplace "gatb-core/gatb-core/src/gatb/system/api/build_info.hpp.in",
              "${CMAKE_C_COMPILER}", "cc"
    hdf5_settings = "gatb-core/gatb-core/thirdparty/hdf5/config/cmake/libhdf5.settings.cmake.in"
    inreplace hdf5_settings, "@CMAKE_C_COMPILER@", "cc"
    inreplace hdf5_settings, "@CMAKE_CXX_COMPILER@", "c++"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "bcalm"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/bcalm")
  end
end
