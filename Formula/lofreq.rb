class Lofreq < Formula
  # cite Wilm_2012: "https://10.1093/nar/gks918"
  desc "Low frequency variant calling in populations"
  homepage "https://csb5.github.io/lofreq/"
  url "https://github.com/CSB5/lofreq/archive/v2.1.3.1.tar.gz"
  sha256 "72ad0165a226ad8601297d5e01d139574f30d0637c70dec543f8d513c26958eb"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4d41c8e305ec4d1b044c6291b00d77d4056d986965dd0746c4f71dc6a61d1cfe" => :sierra
    sha256 "c85acd934a221204fb1b57d31206042df3843b3a91db25b265f35e889c98d9a6" => :x86_64_linux
  end

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python"
  depends_on "zlib" unless OS.mac?

  # Requires to be statically linked against samtools/htslib 1.1
  # Later versions do not work due to API changes
  # See: https://github.com/CSB5/lofreq/issues/52

  resource "samtools" do
    url "https://github.com/samtools/samtools/archive/1.1.tar.gz"
    sha256 "cee231e33b7290be8e07dea43a99b885d9df79d957625ac84879b47ff91cda69"
  end

  resource "htslib" do
    url "https://github.com/samtools/htslib/archive/1.1.tar.gz"
    sha256 "eb0a7918862336518afcaf62e3d7da8b7f87053fd40d88f2d1ab689f7f25923f"
  end

  def install
    htslib = buildpath/"htslib"
    resource("htslib").stage do
      mkdir htslib
      cp_r ".", htslib
      system "make", "-C", htslib
    end

    samtools = buildpath/"samtools"
    resource("samtools").stage do
      mkdir samtools
      cp_r ".", samtools
      system "make", "-C", samtools, "HTSDIR=#{htslib}"
    end

    system "glibtoolize"
    system "./bootstrap"
    system "./configure",
           "--prefix=#{prefix}",
           "SAMTOOLS=#{samtools}",
           "HTSLIB=#{htslib}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lofreq version 2>&1")
  end
end
