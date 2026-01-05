class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "863e299a40b3593dba7ceed25c1c515e5f68567fea88eecf818a9f03b4f263db"
    sha256 cellar: :any,                 arm64_sequoia: "198bdc0b72977696c4f8d74174ce06b75087eac64ae2b98ca64ffe31866c18ad"
    sha256 cellar: :any,                 arm64_sonoma:  "dd64b1fb0882168bbfbf2780aeb159a6fd3de12fcf3ac2580378e1822b0bca8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b07ec087db65771a575b9c164072700b2bf99355dc583e5ecb2c35bd7e60079"
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
