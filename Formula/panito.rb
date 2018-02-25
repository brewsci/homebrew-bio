class Panito < Formula
  desc "Calculate genome wide average nucleotide identity (gwANI)"
  homepage "https://github.com/sanger-pathogens/panito"
  url "https://github.com/sanger-pathogens/panito/archive/0.0.1.tar.gz"
  sha256 "a97047ab12cb73c90a2b5fe73034f5497a3de2c31459f30d6e9ae90db0fe6f0f"
  head "https://github.com/sanger-pathogens/panito.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "autoreconf", "-i", "-f"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "ANI", shell_output("#{bin}/panito -h 2>&1", 0)
  end
end
