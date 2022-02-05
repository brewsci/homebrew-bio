class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://github.com/cctbx/ccp4io"
  url "https://github.com/cctbx/ccp4io/archive/b58c4fb68902e4e6a58f4a585d0722e542516076.tar.gz"
  sha256 "f1edc5a830cd4a078eae700e14b1d89612fb7a12318094363642340aafe41af6"
  license "LGPL-3.0-only"
  head "https://github.com/cctbx/ccp4io.git", branch: "master"

  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build

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
