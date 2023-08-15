class Libcifpp < Formula
  desc "Library containing code to manipulate mmCIF and PDB files"
  homepage "https://github.com/PDB-REDO/libcifpp"
  url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "067964b53dde37a5864a6259878d8e4e121772e5d0dc040f846cd366caac6331"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/libcifpp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 monterey:     "23e26f71f43310dc3eb02e9b3cff97fbbe17f8638b5726250b5d9c1ac04680af"
    sha256 x86_64_linux: "cf4e9a58bbe4ed43c0be17756af653a12cb5cc1546e6fb0a312e2102f28d628e"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  uses_from_macos "zlib"

  resource "libmcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.2.4.tar.gz"
    sha256 "97f7e6271d81fc6b562bd89e7e306315f63d3e3c65d68468217e40ad15ea5164"
  end

  def install
    resource("libmcfp").stage do
      system "cmake", "-S", ".", "-B", "build",
                      *std_cmake_args(install_prefix: prefix/"libmcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build",
                  "-Dlibmcfp_DIR=#{prefix/"libmcfp/lib/cmake/libmcfp"}",
                  "-DCMAKE_BUILD_TYPE=Release",
                  *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags libcifpp")
  end
end
