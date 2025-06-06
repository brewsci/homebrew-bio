class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/libccp4-8.0.0.tar.gz"
  sha256 "cb813ae86612a0866329deab7cee96eac573d81be5b240341d40f9ad5322ff2d"
  license "LGPL-3.0-only"

  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "m4"

  def install
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

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags ccp4c")
  end
end
