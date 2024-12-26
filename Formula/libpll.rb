class Libpll < Formula
  # cite Flouri_2015: "https://doi.org/10.1093/sysbio/syu084"
  desc "Phylogenetic likelihood library"
  homepage "https://github.com/xflouris/libpll-2"
  url "https://github.com/xflouris/libpll-2/archive/refs/tags/0.4.0.tar.gz"
  sha256 "631a9588ab640c851b4ced5124087cf0b7997d33418a59e96a1ed7e97d51d1a5"
  license "AGPL-3.0"
  head "https://github.com/xflouris/libpll.git", branch: "master"

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
