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
    rebuild 1
    sha256 arm64_sequoia: "434cc06634014092558e8460d52d74deebbfe2943f0229e6b15a737f60b81f88"
    sha256 arm64_sonoma:  "7e4c4eef0f1b15103184108765ff972acfab496b8b28df161b9a8df2469afa21"
    sha256 ventura:       "6eea3bada2567049b6fec220245411f71c972a3e1505f77731d34ab49b3bb3a0"
    sha256 x86_64_linux:  "d13d82745d32fa3abbd468758faba5c6fa49151a910c618c8b9558e2b1ae52de"
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
