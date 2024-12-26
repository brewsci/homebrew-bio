class Libpll < Formula
  # cite Flouri_2015: "https://doi.org/10.1093/sysbio/syu084"
  desc "Phylogenetic likelihood library"
  homepage "https://github.com/xflouris/libpll-2"
  url "https://github.com/xflouris/libpll-2/archive/refs/tags/0.4.0.tar.gz"
  sha256 "631a9588ab640c851b4ced5124087cf0b7997d33418a59e96a1ed7e97d51d1a5"
  license "AGPL-3.0"
  head "https://github.com/xflouris/libpll.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_sequoia: "605e3d82ca9ed7374748911cb5b4a5fa5f074517f0b08561d17c8d339e86d241"
    sha256 cellar: :any, arm64_sonoma:  "0744d8c03c6bb7988d6f2ff759faa942284cf76fa3e331bc59ba8e3d4ee61580"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # must use v3.8.2
  depends_on "libtool" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh"
    if Hardware::CPU.arm? && OS.mac?
      system "./configure", "--disable-avx2", "--disable-avx", "--disable-sse", *std_configure_args
      inreplace "src/Makefile", "-mfma -mavx2", "-march=armv8-a+fp+simd"
    end
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    cp_r doc/"examples"/"heterotachy", testpath
    cd "heterotachy" do
      ENV["CPPFLAGS"] = "-I#{include}/libpll"
      system "make"
      system "./heterotachy"
    end
  end
end
