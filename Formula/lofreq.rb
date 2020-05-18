class Lofreq < Formula
  # cite Wilm_2012: "https://10.1093/nar/gks918"
  desc "Low frequency variant calling in populations"
  homepage "https://csb5.github.io/lofreq/"
  url "https://github.com/CSB5/lofreq/archive/v2.1.4.tar.gz"
  sha256 "f0ef22b3019826ea3a160499e89c0d60c7b977f805a385690c3b64a1fae9726b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4d41c8e305ec4d1b044c6291b00d77d4056d986965dd0746c4f71dc6a61d1cfe" => :sierra
    sha256 "c85acd934a221204fb1b57d31206042df3843b3a91db25b265f35e889c98d9a6" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "htslib"
  depends_on "python"
  depends_on "samtools"

  def install
    system "glibtoolize"
    system "./bootstrap"
    system "./configure",
           "--prefix=#{prefix}",
           "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lofreq version 2>&1")
  end
end
