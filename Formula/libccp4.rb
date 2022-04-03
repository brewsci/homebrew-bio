class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://github.com/cctbx/ccp4io"
  url "https://github.com/cctbx/ccp4io/archive/b58c4fb68902e4e6a58f4a585d0722e542516076.tar.gz"
  sha256 "f1edc5a830cd4a078eae700e14b1d89612fb7a12318094363642340aafe41af6"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/cctbx/ccp4io.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 catalina:     "a1016c5a263c1527dd3ecdb7a9e4c744a67d414567349b82c0df6f690412b5b0"
    sha256 x86_64_linux: "c6f12a9841cc3be933a7fce40bb5bdc93b96b3b63d135d5fef24229777fd331d"
  end

  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "m4"

  def install
    cd "libccp4" do
      # not fortran
      args = %W[
        --prefix=#{prefix}
        --enable-shared
        --disable-static
        --disable-fortran
      ]
      system "./configure", *args
      system "make", "install"
    end
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags libccp4c")
  end
end
