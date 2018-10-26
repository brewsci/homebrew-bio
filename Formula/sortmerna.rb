class Sortmerna < Formula
  # cite Kopylova_2012: "http://doi.org/10.1093/bioinformatics/bts611"
  desc "SortMeRNA: filter metatranscriptomic ribosomal RNA"
  homepage "http://bioinfo.lifl.fr/RNA/sortmerna/"
  url "https://github.com/biocore/sortmerna/archive/2.1b.tar.gz"
  sha256 "b3d122776c323813971b35991cda21a2c2f3ce817daba68a4c4e09d4367c0abe"
  head "https://github.com/biocore/sortmerna.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "aa26fd0b1316228b17fcb700bab6a2121af7806435c1657c9cbbf8724ce1f47d" => :sierra
    sha256 "b412dde11f5cb06f8c4a1aa3d78719d0647ffe5a2e9ff81df960903346269bd1" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sortmerna", "--version"
  end
end
