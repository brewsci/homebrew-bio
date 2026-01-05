class CdHit < Formula
  # cite Li_2006: "https://doi.org/10.1093/bioinformatics/btl158"
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "https://sites.google.com/view/cd-hit"
  url "https://github.com/weizhongli/cdhit/archive/refs/tags/V4.8.1.tar.gz"
  sha256 "f8bc3cdd7aebb432fcd35eed0093e7a6413f1e36bbd2a837ebc06e57cdb20b70"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/weizhongli/cdhit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0be33edfd9e6fe0ce4c3758a997d95be804b8d642d0b3244952f7b496b5583b8"
    sha256 cellar: :any,                 arm64_sequoia: "7943f22b01bcc34a9032acc533e90ea97ef12c027f5ec9bf6d35a3c0194799c4"
    sha256 cellar: :any,                 arm64_sonoma:  "4efba7d3141dcb7b3c3924b85665b72285d407ff41672e885159cd92e1eeb1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155b52979927e27c3d8a6bc594ad1a3c31e951b6beaa547bc24df3d88063404a"
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
