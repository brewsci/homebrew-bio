class Lofreq < Formula
  # cite Wilm_2012: "https://10.1093/nar/gks918"
  desc "Low frequency variant calling in populations"
  homepage "https://csb5.github.io/lofreq/"
  url "https://github.com/CSB5/lofreq/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "da85ec4baca21e20a55b5f9ee491cdda2986d0dc672177007a2c70ca1d804fe7"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "4d41c8e305ec4d1b044c6291b00d77d4056d986965dd0746c4f71dc6a61d1cfe"
    sha256 x86_64_linux: "c85acd934a221204fb1b57d31206042df3843b3a91db25b265f35e889c98d9a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "htslib"
  depends_on "python"

  uses_from_macos "zlib"

  # Since 2.1.4, lofreq builds against a regular HTSlib installation
  # (--with-htslib) instead of vendoring a pinned samtools/htslib 1.1 pair.
  # See the "Changes in 2.1.4" entry in the upstream Changelog.

  def install
    system "glibtoolize"
    system "./bootstrap"
    # Skip automake dependency-tracking; its config.status "depfiles" bootstrap
    # fails on Linux ("Something went wrong bootstrapping makefile fragments"),
    # and it is unneeded for a one-shot build.
    system "./configure",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-htslib=#{formula_opt_prefix("htslib")}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lofreq version 2>&1")
  end
end
