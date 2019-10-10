class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.3.tar.gz"
  sha256 "c31ea092cd38c784c3d00f03959be42462a002de0d6a024effbd7b5ff829951b"

  def install
    # https://github.com/tothuhien/lsd2/issues/5
    inreplace "src/makefile", "FLAGS=", "FLAGS=-Ofast -Wall "
    system "make", "-C", "src"
    bin.install "src/lsd2"
    pkgshare.install "examples"
  end

  test do
    assert_match "confidence", shell_output("#{bin}/lsd2 -h 2>&1")
  end
end
