class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler based on a de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v3.2.4/minia-v3.2.4-Source.tar.gz"
  sha256 "76127395b0a7ae76069692c1d23b1595c5d337196db96e8d79be7cd46f442286"
  license "AGPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0aa4268b6671d25ab642c61e5c848708c65385f28424096a2c16e8a25e1882c5" => :sierra
    sha256 "987ae35c73a400c072f82b5e801fc660eb14c5c9c25ac3b82f5df6c7614c2ce7" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # ENV["CC"] = ENV.cc
    # ENV["CXX"] = ENV.cxx
    mkdir "build" do
      cc = OS.mac? ? "/usr/bin/clang" : "/usr/bin/gcc"
      cxx = OS.mac? ? "/usr/bin/clang++" : "/usr/bin/g++"
      args = std_cmake_args + [
        "-DSKIP_DOC=1",
        "-DCMAKE_C_COMPILER=#{cc}",
        "-DCMAKE_CXX_COMPILER=#{cxx}",
      ]
      system "cmake", "..", *args
      # os = OS.mac? ? "mac" : "linux"
      # files = [
      #   "../src/build_info.hpp",
      #   "CMakeCache.txt",
      #   "CMakeFiles/#{Formula["cmake"].version}/CMakeCCompiler.cmake",
      #   "CMakeFiles/#{Formula["cmake"].version}/CMakeCXXCompiler.cmake",
      #   "ext/gatb-core/include/gatb/system/api/build_info.hpp",
      #   "ext/gatb-core/thirdparty/hdf5/CMakeFiles/h5cc",
      #   "ext/gatb-core/thirdparty/hdf5/DartConfiguration.tcl",
      #   "ext/gatb-core/thirdparty/hdf5/libhdf5.settings",
      # ]
      # inreplace files, "#{HOMEBREW_LIBRARY}/Homebrew/shims/#{os}/super/", "/usr/bin/"
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
