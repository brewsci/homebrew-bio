class Sortmerna < Formula
  desc "SortMeRNA: filter metatranscriptomic ribosomal RNA"
  homepage "http://bioinfo.lifl.fr/RNA/sortmerna/"
  # doi "10.1093/bioinformatics/bts611"
  # tag "bioinformatics"

  url "https://github.com/biocore/sortmerna/archive/2.1b.tar.gz"
  sha256 "b3d122776c323813971b35991cda21a2c2f3ce817daba68a4c4e09d4367c0abe"

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
