class Ekidna < Formula
  desc "Assembly based core genome SNP alignments for bacteria"
  homepage "https://github.com/tseemann/ekidna"
  url "https://github.com/tseemann/ekidna/archive/v0.3.0.tar.gz"
  sha256 "c2d1cd7f94a4e8066b98296743dfe7386853df5ff2016e30dec87fb0f8c8bfe9"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ekidna -v")
  end
end
