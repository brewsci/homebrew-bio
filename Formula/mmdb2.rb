class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.20.tar.gz"
  sha256 "bd86716a1005b161e7b6a7c93902a7cc1220efa9d757e1f6bdf6532e766624e3"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any,                 catalina:     "70b301e437f12834fd9d52b1d0fa4f5e90ae7855a0cf491d69b8733a64e3a938"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "864b30f348f65f3999eb51745604fd12c51a25bb1582ababc237f20221f8ada7"
  end

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
