class Disty < Formula
  desc "Compute a distance matrix from a core genome alignment file"
  homepage "https://github.com/c2-d2/disty"
  url "https://github.com/c2-d2/disty/archive/0.1.0.tar.gz"
  sha256 "4fe8a37e1545904af226ffc7c38e3776d6b1fe7640b792fad6d9d3b30abc7bd2"
  head "https://github.com/c2-d2/disty.git"

  bottle do
  end

  depends_on "zlib" unless OS.mac?

  def install
    ENV.cxx11
    system "make"
    bin.install "disty"
    pkgshare.install "tests"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/disty -h", 0)
    cp_r pkgshare/"tests", "."
    system "make", "-C", "tests", "DM=#{bin}/disty"
  end
end
