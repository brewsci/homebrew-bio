class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://ccp4forge.rc-harwell.ac.uk/ccp4/mmdb2/-/archive/2.0.24/mmdb2-2.0.24.tar.bz2"
  sha256 "aa904db3b57740741c5483e384231d19c4bfc0bf4cd962bbb1b979703ed6c9d1"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_golden_gate: "25802db3d6c447462aa25b8c90ebe7d8bd4b377b0a7c2e562cb7bd1c0b6f9760"
    sha256 cellar: :any, arm64_tahoe:       "c72734b3b86b48bd3d0e7dc6b2ff07b8ccddd6a50a9236ce11781c8c39dfc0bc"
    sha256 cellar: :any, arm64_sequoia:     "fcde753c66b968c54104ed7550d7330de064cd2c0cda868021996c3c3a8ae39b"
    sha256 cellar: :any, x86_64_linux:      "2aea42e6d4ad900fdd16ee219623cde8eb5aad3dfc0fc90118b632db322ca392"
  end

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
