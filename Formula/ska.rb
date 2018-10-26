class Ska < Formula
  desc "Split Kmer Analysis toolkit"
  homepage "https://github.com/simonrharris/SKA/releases"
  url "https://github.com/simonrharris/SKA/archive/v1.0.tar.gz"
  sha256 "fc6110c22c756158b190f50dc11d596265f9b0d09c28725b2b23ed22e2e4fbff"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    # https://github.com/simonrharris/SKA/issues/13 | make install failure
    bin.install "bin/ska"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ska version 2>&1")
  end
end
