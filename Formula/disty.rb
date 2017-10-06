class Disty < Formula
  desc "Compute a distance matrix from a core genome alignment file"
  homepage "https://github.com/c2-d2/disty"
  url "https://github.com/c2-d2/disty/archive/0.1.0.tar.gz"
  sha256 "4fe8a37e1545904af226ffc7c38e3776d6b1fe7640b792fad6d9d3b30abc7bd2"
  head "https://github.com/c2-d2/disty.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bioinformatics"
    cellar :any_skip_relocation
    sha256 "9bab5668fa42664db36c92a074f702476244df9c996f295ae4c219b83b320ad6" => :sierra
    sha256 "edf30b6426650f13f3d73ec110db19c1afde67971151b41e29e1f084b0f4d2b8" => :x86_64_linux
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
