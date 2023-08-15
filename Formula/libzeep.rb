class Libzeep < Formula
  desc "Web application framework written in C++"
  homepage "https://github.com/mhekkel/libzeep"
  url "https://github.com/mhekkel/libzeep/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "0788bcd4122046d403220b23979dc2e33564adcc6f279c7529ffd2bff3212045"
  license "BSL-1.0"
  head "https://github.com/mhekkel/libzeep.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "a3dea66429a4da315f1951c45b6febd841bb3dbfda0e4727cff69fea59e5ca66"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8712c2089d5d8d8beeb8858a42c987790bf6e2569ba1022c44843501358cd50a"
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
