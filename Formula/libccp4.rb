class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://github.com/cctbx/ccp4io"
  url "https://github.com/cctbx/ccp4io/archive/b58c4fb68902e4e6a58f4a585d0722e542516076.tar.gz"
  sha256 "f1edc5a830cd4a078eae700e14b1d89612fb7a12318094363642340aafe41af6"
  license "LGPL-3.0-only"
  revision 2
  head "https://github.com/cctbx/ccp4io.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sonoma: "36ecf6529774cc6ccee9898c3479da2f05cdb788c64eea6634dd208ad9f47ba4"
    sha256 ventura:      "887f422cc4ffb2cb469386ebec0c20177c29553a0cafe8d7af74dd594c954016"
    sha256 x86_64_linux: "c45597f3e540bff35b80e11bb45b5816dd7c779d202b5e6c6e5356111684dc63"
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
