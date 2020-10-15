class Psmc < Formula
  # cite Li_2011: "https://doi.org/10.1038/nature10231"
  desc "Implementation of the Pairwise Sequentially Markovian Coalescent (PSMC) model"
  homepage "https://github.com/lh3/psmc"
  url "https://github.com/lh3/psmc/archive/0.6.5.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"
  license "MIT"
  depends_on "zlib"

  def install
    system "make", "all"
    mkdir "#{bin}/"
    copy "psmc", "#{bin}/"
  end

  test do
    system "#{bin}/psmc", "1"
  end
end
