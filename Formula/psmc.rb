class Psmc < Formula
  # cite Li_2011: "https://doi.org/10.1038/nature10231"
  desc "Implementation of the Pairwise Sequentially Markovian Coalescent (PSMC) model"
  homepage "https://github.com/lh3/psmc"
  url "https://github.com/lh3/psmc/archive/0.6.5.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "27f4f32c8217f4f2278557e11b3a438da2c18f2be7d271e7a0f9f1d5659fb9e9" => :catalina
    sha256 "ce3be20a3670f14e31c13222446f8c6fd2ae533c696405a8226d254058a7f525" => :x86_64_linux
  end

  depends_on "zlib"

  def install
    system "make"
    bin.install "psmc"
  end

  test do
    system "#{bin}/psmc", "1"
  end
end
