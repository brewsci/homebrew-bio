class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "e4f2b345366f463026a76d6998b4ecd9f7ec81e5beed1e0ca131b1b9b3e92d09"
    sha256 cellar: :any,                 ventura:      "057dc30ebc07fbb25268aebec5e7966374c097456f251ae8e68d9da18283ffad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4775e106c2a1b7fe8a4d70c64ab2de1cc4cc02b95a8405dafabb2e94c8be58c8"
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
