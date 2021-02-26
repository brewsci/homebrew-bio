class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.20.tar.gz"
  sha256 "bd86716a1005b161e7b6a7c93902a7cc1220efa9d757e1f6bdf6532e766624e3"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "8894b970173f65fbea636a9c5df831b292fc75c2c43ceeae00b60ce694fb41b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e439c80170a0a0bf4e5f4c01af422643b8a85fd5d4b6a202ac71d537d3de6e46"
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
