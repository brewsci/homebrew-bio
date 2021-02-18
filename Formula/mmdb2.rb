class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.20.tar.gz"
  sha256 "bd86716a1005b161e7b6a7c93902a7cc1220efa9d757e1f6bdf6532e766624e3"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  depends_on "pkg-config" => [:build, :test]

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags mmdb2")
  end
end
