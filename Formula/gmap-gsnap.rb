class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2025-07-31.v2.tar.gz"
  sha256 "c4a0121d84edb7c887ea6a6c1dfc6b2f21aaaa7e663a72b8962a07e8ea125b56"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/href=.*?gmap-gsnap-(\d\d\d\d-\d\d-\d\d)(\.v\d+)?\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9874be6c901296c0346907065f5caed0f90b321f1c9626a93a517a9c9f190a1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50a6eb56ac910479e81d2237b6df732383ad45c33f617c89d34f57cc927ca59b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c3eaad20bb18fd247ae2eed30189111820710ea9e02ed0cd3ff3f3578b7ca3a"
    sha256 cellar: :any,                 x86_64_linux:  "f374fc88685f4291845ebbd80cff752106a05e3fa3a54afd9d6a2896eb0f821e"
  end

  depends_on "samtools"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # The binary links libz, provided by zlib-ng-compat on Linux; declare it
  # directly so it is not flagged as an indirect-dependency linkage.
  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # gmap 2025 builds several SIMD-level binaries (sse42, avx2, nosimd, ...)
    # and dispatches at runtime, so the bottle stays portable without pinning
    # a level (and --with-simd-level=sse42 no longer builds in this release).
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # The test suite shares output files between cases and races under a
    # parallel make, so run it serially.
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
    assert_match version.to_s, shell_output("#{bin}/gmap --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/gsnap --version 2>&1")
  end
end
