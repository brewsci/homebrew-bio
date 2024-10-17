class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  depends_on "pkg-config" => [:build, :test]

  def install
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
