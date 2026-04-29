class Mmdb2 < Formula
  desc "C++ toolkit for working with macromolecular coordinate files"
  homepage "https://www2.mrc-lmb.cam.ac.uk/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/mmdb2-2.0.22.tar.gz"
  sha256 "a9646933ce9f34633e1ae4901f2383af0e5318d6490851328f5b6aa06195ab51"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "c1a635773646d051f3ee7555f85fb38c55785ddfeb515ccb49e852c94b013529"
    sha256 cellar: :any,                 arm64_sequoia: "4a58793e2b06d299ea6515dfb801cd2b706a763c4a7f150b8315134d6d640972"
    sha256 cellar: :any,                 arm64_sonoma:  "e18f1bf54d7ce386dc01a9264d009fc9d2d3efd56248e1dfd170ef698ea771d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed68526ac7c2e3ede6248cef4904df10e9cee7ee1ca8140838b9ca3eff4e1c8"
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
