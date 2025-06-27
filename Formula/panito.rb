class Panito < Formula
  desc "Calculate genome wide average nucleotide identity (gwANI)"
  homepage "https://github.com/sanger-pathogens/panito"
  url "https://github.com/sanger-pathogens/panito/archive/0.0.1.tar.gz"
  sha256 "a97047ab12cb73c90a2b5fe73034f5497a3de2c31459f30d6e9ae90db0fe6f0f"
  head "https://github.com/sanger-pathogens/panito.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "f8069888845a117be27072cd9393e0859d639372bb5588df4b7ddd84eec1bbcd"
    sha256 cellar: :any, x86_64_linux: "84a55028b58cdc1bd02b9d2d2a08caf4104da89e045a22af0a0f60e57b210450"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-i", "-f"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "ANI", shell_output("#{bin}/panito -h 2>&1")
  end
end
