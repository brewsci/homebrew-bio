class Disty < Formula
  desc "Compute a distance matrix from a core genome alignment file"
  homepage "https://github.com/c2-d2/disty"
  url "https://github.com/c2-d2/disty/archive/0.1.0.tar.gz"
  sha256 "4fe8a37e1545904af226ffc7c38e3776d6b1fe7640b792fad6d9d3b30abc7bd2"
  license "MIT"
  head "https://github.com/c2-d2/disty.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "d24b94571782ba8cb2f3e6b9fabb561e95faced3abeff0158793cde07a7abf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4478bc5857ec7f219d836dc5b599ee72e407e4cd34018a11daf4d7dbbd01f52"
  end

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    system "make"
    bin.install "disty"
    pkgshare.install "tests"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/disty -h")
    cp_r pkgshare/"tests", "."
    system "make", "-C", "tests", "DM=#{bin}/disty"
  end
end
