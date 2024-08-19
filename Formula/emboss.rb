class Emboss < Formula
  # cite Rice_2000: "https://doi.org/10.1016/S0168-9525(00)02024-2"
  desc "European Molecular Biology Open Software Suite"
  homepage "https://emboss.sourceforge.io/"
  url "https://github.com/kimrutherford/EMBOSS/archive/refs/tags/EMBOSS-6.6.0.tar.gz"
  sha256 "85f53a19125735e4a49fc25620d507fd86bf189e49096578924fe04893f2f7a9"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 big_sur:      "5009f9093ca395f5b905a5cc65a8173056f28bccba378cc1fcfdcdfc4458f4be"
    sha256 x86_64_linux: "2fd2530f68175c115e478a262323bdba8871b9407873723af2c164067c096e99"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  depends_on "brewsci/bio/clustal-w"
  depends_on "gd"
  depends_on "libharu"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    # Regenerate configure to fix flat namespace errors on macOS 11+
    system "autoreconf", "-fvi"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --docdir=#{doc}
      --enable-64
      --with-thread
      --with-hpdf=#{Formula["libharu"].opt_prefix}
      --with-pngdriver=#{HOMEBREW_PREFIX}
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      If you have copied the binaries to another directory instead, or
      made other changes to the file locations, you can also use
      environment variables or the embossrc file(s) to tell the programs
      where to look

      You may need to use this command:
        export EMBOSS_ACDROOT=$(brew --prefix)/share/EMBOSS/acd

        or in your site emboss.default file (in the share/EMBOSS install
      directory or under emboss/ in the original source directory) or in
      ~/.embossrc file put
        export EMBOSS_ACDROOT=$(brew --prefix)/share/EMBOSS/acd
    EOS
  end
  test do
    assert_match "5\n", shell_output("#{bin}/seqcount -auto -filter #{share}/EMBOSS/test/data/tranalign.pep")
  end
end
