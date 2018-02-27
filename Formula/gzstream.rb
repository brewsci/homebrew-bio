class Gzstream < Formula
  desc "C++ iostream wrapper for the zlib C library"
  homepage "https://www.cs.unc.edu/Research/compgeom/gzstream/"
  url "https://www.cs.unc.edu/Research/compgeom/gzstream/gzstream.tgz"
  version "1.5"
  sha256 "99acb23903dd0e41ee86c29f65b9f36a8f43af29325dd233fb45362df14dc103"

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
