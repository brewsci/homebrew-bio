class Ska < Formula
  desc "Split Kmer Analysis toolkit"
  homepage "https://github.com/simonrharris/SKA/releases"
  url "https://github.com/simonrharris/SKA/archive/v1.0.tar.gz"
  sha256 "fc6110c22c756158b190f50dc11d596265f9b0d09c28725b2b23ed22e2e4fbff"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fbd0265e5781a5ab96d69bf46d1616b1e8b9c53eef03316cb25ceeed50d90d73" => :sierra
    sha256 "caafb54652a88112431cbc92b5885602b3e97dc9722364dd168b252fa2d5b04b" => :x86_64_linux
  end

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
