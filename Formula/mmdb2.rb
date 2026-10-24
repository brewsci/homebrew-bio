class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 4
    sha256 cellar: :any, arm64_golden_gate: "03edeb7505ec042b121a31ce367b3920864f8fc4fac778348fbb716e70330e2f"
    sha256 cellar: :any, arm64_tahoe:       "fd330e6a16b8203689be3c7773a526e4d80bd38bc28ac03c5e42d93e3801c354"
    sha256 cellar: :any, arm64_sequoia:     "ca07d41656c75c13b67ba5379b7039b2b0859cc29bb30f3e22dd2b234c01d62d"
    sha256 cellar: :any, x86_64_linux:      "3f3534914839eb553091fa617549b96c8bdfc218803261bc93ae42b7bc5fb904"
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
