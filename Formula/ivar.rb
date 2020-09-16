class Ivar < Formula
  # cite Grubaugh_2019: "https://doi.org/10.1101/383513"
  desc "Viral amplicon-based sequencing pipeline"
  homepage "https://github.com/andersen-lab/ivar"
  url "https://github.com/andersen-lab/ivar/archive/v1.2.2.tar.gz"
  sha256 "b09a5b871e1b7b8babb69b96609e7ac28db33c1a2b6febe6eb3b8a5dc1e41f44"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "5f58bf0568e9a1fea3ef86f367aa834c2df723dd0ac86a516c4a0d0c568955c2" => :catalina
    sha256 "6457f2f6687d1b86b1ffd7448841d416561378302bfe288cf4504bf02dfda516" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "htslib"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ivar version 2>&1")
  end
end
