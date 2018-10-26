class SnpSites < Formula
  # cite Page_2016: "https://doi.org/10.1099/mgen.0.000056"
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/v2.4.0.tar.gz"
  sha256 "4ccbf6016b37ba1aae67ee8dd265537098eb9a7965186deb0b862efd7c416ae6"
  head "https://github.com/sanger-pathogens/snp-sites.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "963f1b2cce96f685098ff185edb6607c45c5e65119084d254b1261071f914579" => :sierra
    sha256 "0721484daa84e9bbd74d54f20ad17d1918ad78849f98999f6c48c1ce88a745fa" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "check" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "zlib" unless OS.mac?

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snp-sites -V 2>&1")
  end
end
