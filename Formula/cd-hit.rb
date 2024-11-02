class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  url "https://github.com/weizhongli/cdhit/archive/refs/tags/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/weizhongli/cdhit.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7956683c00ba17abb83c248102faf10bb17d3baf4b6d12b1f573c606324c2eef"
    sha256 cellar: :any,                 arm64_sonoma:  "33f0107f7883c65ca99bd0b5a4f1ecc9da20c8678fb86a756800ea01133e66ce"
    sha256 cellar: :any,                 ventura:       "c2afa662f007e4bc4f3c286c12c56b02c70b2ca6f13db174101ea942e0c45c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f6b333033936097328fd30711518f67d35f326bf0a158b15b5010bafbf3b72"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace "Makefile", "-fopenmp", "-L#{Formula["libomp"].opt_lib} -lomp" if OS.mac?
    bin.mkpath
    system "make"
    system "make", "PREFIX=#{bin}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
