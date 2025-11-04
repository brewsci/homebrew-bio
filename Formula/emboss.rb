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
    rebuild 3
    sha256 arm64_tahoe:   "ae800cbbf7c51b416b043777fab63ed8aa28ad02307df26047b6efd963b5a9c1"
    sha256 arm64_sequoia: "d19cda26e755bb5d29e0cc57c7f55c36e9a0677aea6d97f7d7b3aea2a3a44da9"
    sha256 arm64_sonoma:  "d583bd3056ea3184c96f1768e831da7e4422b8bdbe9df2353e4093589597fec9"
    sha256 x86_64_linux:  "1122f6d0d8c03f074fb8d795066e1af9a0499c678090046ec9b844eff616be30"
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
