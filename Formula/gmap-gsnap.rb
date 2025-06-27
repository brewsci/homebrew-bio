class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2019-09-12.tar.gz"
  sha256 "1bf242eef2ad0ab0280c41fc28b44a5107e90bcba64b37cf1579e1793e892505"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, mojave:       "b907aaa226905eaacde9dd120f17046a6a2b56b8a7af9425f0a1b16c682a9f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4d6d09f1b7f4633054f9219d105a6fe459f71e7bcd7e35937852df240452a59"
  end

  depends_on "samtools"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # homebrew currently supports SSE4.2 and don't want to force AVX-512
    system "./configure", "--prefix=#{prefix}", "--with-simd-level=sse42"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You will need to either download or build indexed search databases.
      See the readme file for how to do this:
        http://research-pub.gene.com/gmap/src/README

      Databases will be installed to:
        #{share}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsnap --version 2>&1")
  end
end
