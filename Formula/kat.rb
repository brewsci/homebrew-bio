class Kat < Formula
  # cite Mapleson_2016: "https://doi.org/10.1093/bioinformatics/btw663"
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/archive/Release-2.4.1.tar.gz"
  sha256 "068bd63b022588058d2ecae817140ca67bba81a9949c754c6147175d73b32387"
  license "GPL-3.0"
  revision 3
  head "https://github.com/TGAC/KAT.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/Release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    rebuild 1
    sha256 catalina:     "3de60b22d45daa5e28f03bb4f577c1ff14409f46f3fddb19407737b42e8392df"
    sha256 x86_64_linux: "232a183bdce0f0a9565fc39aacf8cfe4ec019e4c86cf6f64a9177e96ca64bbd2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "brewsci/bio/matplotlib"
  depends_on "numpy"
  depends_on "scipy"

  def install
    # Disable unsupported compiler flags on macOS
    inreplace [
      "deps/boost/tools/build/src/tools/darwin.py",
      "deps/boost/tools/build/src/tools/darwin.jam",
    ] do |s|
      s.gsub! "-fcoalesce-templates", ""
      s.gsub! "-Wno-long-double", ""
    end

    system "./build_boost.sh"
    system "./autogen.sh"
    system "./configure",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-pykat-install",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
  end
end
