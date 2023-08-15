class Libzeep < Formula
  desc "Web application framework written in C++"
  homepage "https://github.com/mhekkel/libzeep"
  url "https://github.com/mhekkel/libzeep/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "0788bcd4122046d403220b23979dc2e33564adcc6f279c7529ffd2bff3212045"
  license "BSL-1.0"
  head "https://github.com/mhekkel/libzeep.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 monterey:     "41258503b8ea048bc91779fc59f3a3bd1f3151de7ecdf1a0526c2e97a0984068"
    sha256 x86_64_linux: "87d38a0169af31362912fe3774d142cea5a5c84b5e42266d570b4dc628d03a71"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "howard-hinnant-date"

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
                  "-DCMAKE_BUILD_TYPE=Release",
                  *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags libzeep")
  end
end
