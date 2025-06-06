class Clipper4coot < Formula
  desc "Crystallographic automation and complex data manipulation libraries"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/clipper-2.1.20180802.tar.gz"
  sha256 "7c7774f224b59458e0faa104d209da906c129523fa737e81eb3b99ec772b81e0"
  license "LGPL-2.1-only"
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1328ca2938e4a8fc8164a7a6b940b370f68d602648bbe9af0552cbf20e05f7d9"
    sha256 cellar: :any,                 arm64_sonoma:  "c43e299e174bf0710d18275cbf3e51c64ad3a4d336f485c05f8176fa0f41d86c"
    sha256 cellar: :any,                 ventura:       "c388209e0e65f28d39279270ff5ffa78769e910de6bdb0eefebe2ec7eabdabeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8a620c4fd7be0ff47dfea7ec613e7d35458e69f5e1f39dbf00c0bdb6eb1808"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "texinfo" => :build
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"

  resource "libfftw2" do
    url "https://fftw.org/fftw-2.1.5.tar.gz"
    sha256 "f8057fae1c7df8b99116783ef3e94a6a44518d49c72e2e630c24b689c6022630"
  end

  patch :p0 do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/clipper-configure-2.patch"
    sha256 "3cf0a68163451773e9764c11c740fcbd1a91daf9d5782d94049b90f3cd1fe5ae"
  end

  def install
    # required to prevent flat namespace issues on macOS
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
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
        "--disable-static",
      ]
      # Hack for M1 Mac (https://github.com/pemsley/coot/issues/33#issuecomment-1086907650)
      if Hardware::CPU.arm? && OS.mac?
        args << "--build=arm-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"
      end
      inreplace "./configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup" if OS.mac?
      # fix missing "config.h" error on Linux
      ENV.append "CPPFLAGS", "-I#{fftw2_dir}/fftw" unless OS.mac?
      # fix "fftw.texi" error when using latest texinfo
      inreplace "doc/fftw.texi", "{FFTW User's Manual}", " FFTW User's Manual"
      inreplace "doc/fftw.texi", "{Matteo Frigo}", " Matteo Frigo"
      inreplace "doc/fftw.texi", "{Steven G. Johnson}", " Steven G. Johnson"
      inreplace "doc/fftw.texi", " --- The Detailed Node Listing ---", "\n--- The Detailed Node Listing ---"
      system "./configure", *args
      system "make", "install"
    end

    # install clipper using fftw2 described above
    ENV["CXXFLAGS"] = "-g -O2 -fno-strict-aliasing -Wno-narrowing"
    ENV.append "LDFLAGS", "-L#{prefix}/fftw2/lib"
    ENV.append "CPPFLAGS", "-I#{prefix}/fftw2/include"
    # --enable-shared is required for coot
    args = [
      "--prefix=#{prefix}",
      "--enable-mmdb",
      "--enable-ccp4",
      "--enable-cif",
      "--enable-minimol",
      "--enable-cns",
      "--enable-shared",
      "--disable-static",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags clipper")
  end
end
