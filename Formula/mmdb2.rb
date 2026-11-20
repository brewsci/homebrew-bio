class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://ccp4forge.rc-harwell.ac.uk/ccp4/mmdb2/-/archive/2.0.24/mmdb2-2.0.24.tar.bz2"
  sha256 "aa904db3b57740741c5483e384231d19c4bfc0bf4cd962bbb1b979703ed6c9d1"
  license "GPL-3.0-only"

  depends_on "pkg-config" => [:build, :test]

  def install
    if OS.mac?
      # Fix error: unknown type name 'size_t';
      # https://github.com/brewsci/homebrew-bio/issues/2181
      inreplace "mmdb2/mmdb_machine_.h", "#include \"mmdb_mattype.h\"",
                "#include <stddef.h>\n#include \"mmdb_mattype.h\""
    end
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-static
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags mmdb2")
  end
end
