class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://www.ccp4.ac.uk/"
  url "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/libccp4/6.5.1-5/libccp4_6.5.1.orig.tar.gz"
  sha256 "280b473d950cdf8837ef66147ec581104298b892399bd856f13b096f2395dbe5"
  license "LGPL-3.0-only"

  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build

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
    assert_match "-I#{include}", shell_output("pkg-config --cflags libccp4c")
  end
end
