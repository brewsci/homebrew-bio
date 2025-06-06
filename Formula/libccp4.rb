class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/libccp4-8.0.0.tar.gz"
  sha256 "cb813ae86612a0866329deab7cee96eac573d81be5b240341d40f9ad5322ff2d"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "8d1804e2a1f0e762f18b4f043983ef0ae269332268997e95ef9211b4ce0e09d0"
    sha256 arm64_sonoma:  "1a379e8e3a312e98b5135ca117345d90b9b2bf66c33193cdfd636c6badbf7e83"
    sha256 ventura:       "bc0a2c04b4914fe7b78faea2692da15e34c38e04573fc844507e685d3ffe7510"
    sha256 x86_64_linux:  "d2126d51495f1dc50b07fcc6293fa771c7b46075a83ada412af6307717ddcc76"
  end

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
