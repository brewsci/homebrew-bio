class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler based on a de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v3.2.6/minia-v3.2.6-Source.tar.gz"
  sha256 "e078854c92d6683d984c8010023e8e0ae2c83fd01d75350d29874b0fa00cef0f"
  license "AGPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "0aa4268b6671d25ab642c61e5c848708c65385f28424096a2c16e8a25e1882c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "987ae35c73a400c072f82b5e801fc660eb14c5c9c25ac3b82f5df6c7614c2ce7"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # newer GCC needs explicit <cstdint> for uintN_t in bundled gatb-core/kff
    ENV.append "CXXFLAGS", "-include cstdint"

    if OS.linux?
      # Homebrew's Linux superenv compiles through a shims wrapper. gatb-core
      # and the bundled HDF5 bake that wrapper's path into compiler-banner
      # strings compiled into bin/minia, and into the bin/h5cc wrapper script,
      # which trips brew audit's "references to the Homebrew shims directory"
      # check. Replace the compiler placeholders at their source before cmake.
      inreplace Dir["src/build_info.hpp.in",
                    "thirdparty/gatb-core/**/src/gatb/system/api/build_info.hpp.in"],
                "${CMAKE_C_COMPILER}", "cc"
      inreplace Dir["thirdparty/gatb-core/**/hdf5/config/cmake/libhdf5.settings.cmake.in"] do |s|
        s.gsub! "@CMAKE_C_COMPILER@", "cc"
        s.gsub! "@CMAKE_CXX_COMPILER@", "c++"
      end
      inreplace Dir["thirdparty/gatb-core/**/hdf5/config/cmake/libh5cc.in"],
                "@_PKG_CONFIG_COMPILER@", "cc"
    end

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      args << "-DSKIP_DOC=1"
      system "cmake", "-S", "..", "-B", ".", *args
      system "make"
      system "make", "install"
    end
    # Installing non-libraries to "lib" is discouraged.
    rm lib/"libhdf5.settings"
    # remove test folder as 250MB is too big for bottles
    rm_r prefix/"test"
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
