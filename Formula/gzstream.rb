class Gzstream < Formula
  desc "C++ iostream wrapper for the zlib C library"
  homepage "https://www.cs.unc.edu/Research/compgeom/gzstream/"
  url "https://www.cs.unc.edu/Research/compgeom/gzstream/gzstream.tgz"
  version "1.5"
  sha256 "99acb23903dd0e41ee86c29f65b9f36a8f43af29325dd233fb45362df14dc103"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "146b9e6ac4dc3a12cb0398092f68bfa08fd5cff5166d20bd6c17e22b27214ed4" => :sierra
    sha256 "a7f86908d5605d7c9464136a96ae692147e2889f8d4ee56b8ace305bfb799414" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    system "make", "test"
    lib.install "libgzstream.a"
    # not readable by others
    chmod 0644, "gzstream.h"
    include.install "gzstream.h"
    doc.install "README", "index.html", "logo.gif", "COPYING.LIB"
    pkgshare.install Dir["test_*.C"], "Makefile"
  end

  test do
    # test was done above in "make test"
  end
end
