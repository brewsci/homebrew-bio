class Clipper4coot < Formula
  desc "Crystallographic automation and complex data manipulation libraries"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/clipper-2.1.20180802.tar.gz"
  sha256 "7c7774f224b59458e0faa104d209da906c129523fa737e81eb3b99ec772b81e0"
  license "LGPL-2.1-only"

  depends_on "binutils" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"
  depends_on "glib"

  resource "libfftw2" do
    url "http://www.fftw.org/fftw-2.1.5.tar.gz"
    sha256 "f8057fae1c7df8b99116783ef3e94a6a44518d49c72e2e630c24b689c6022630"
  end

  patch :p0 do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/clipper-configure-2.patch"
    sha256 "3cf0a68163451773e9764c11c740fcbd1a91daf9d5782d94049b90f3cd1fe5ae"
  end

  def install
    # install legacy fftw version 2.1.5, only single precision.
    fftw2_dir = buildpath/"fftw2"
    resource("libfftw2").stage do
      mkdir fftw2_dir
      cp_r ".", fftw2_dir
    end
    cd fftw2_dir do
      args = [
        "--prefix=#{prefix}/fftw2",
        "--enable-shared",
        "--enable-float",
      ]
      simd_args = []
      simd_args << "--enable-sse2" << "--enable-avx" if Hardware::CPU.intel?
      system "./configure", *(args + simd_args)
      system "make", "-j#{ENV.make_jobs}", "install"
    end

    # install clipper using fftw2 described above
    ENV["CXXFLAGS"] = "-g -O2 -fno-strict-aliasing -Wno-narrowing"
    ENV.append "LDFLAGS", "-L#{prefix}/fftw2/lib"
    ENV.append "CPPFLAGS", "-I#{prefix}/fftw2/include"
    args = %W[
      --prefix=#{prefix}
      --enable-mmdb
      --enable-ccp4
      --enable-cif
      --enable-minimol
      --enable-cns
    ]
    system "./configure", *args
    system "make", "-j#{ENV.make_jobs}", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags clipper")
  end
end
