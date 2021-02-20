class Ssm < Formula
  # cite Krissinel_2004: "https://doi.org/10.1107/S0907444904026460"
  desc "Secondary-structure matching, tool for fast protein structure alignment"
  homepage "https://www2.mrc-lmb.cam.ac.uk"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/ssm-1.4.tar.gz"
  sha256 "56e7e64ed86d7d9ec59500fd34f26f881bdb9d541916d9a817c3bfb8cf0e9508"
  license "GPL-3.0-only"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "0cea947187c889476c284ed284120c4d33ea298140ced301a8da6b5aae78b352"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b88c88c5b518517046acfe08fd37b382765a7ee7c05d6c24cfdc4e843adb31e"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-static
      --enable-ccp4
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags ssm")
  end
end
