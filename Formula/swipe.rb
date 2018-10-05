class Swipe < Formula
  # Rognes 2011: "https://doi.org/10.1186/1471-2105-12-221"
  desc "Smith-Waterman database searches with inter-sequence SIMD parallelisation"
  homepage "http://dna.uio.no/swipe/"
  url "https://github.com/torognes/swipe/archive/v2.1.0.tar.gz"
  sha256 "9706cc1419bba9e4d77e2afb3565ac4f0f34abc294c5c2d0914325ab3207859f"

  needs :cxx11

  def install
    system "make", "swipe", "COMMON="
    bin.install "swipe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swipe -h version 2>&1", 1)
  end
end
