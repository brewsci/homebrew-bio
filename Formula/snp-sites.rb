class SnpSites < Formula
  # cite Page_2016: "https://dx.doi.org/10.1099/mgen.0.000056"
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/v2.4.0.tar.gz"
  sha256 "4ccbf6016b37ba1aae67ee8dd265537098eb9a7965186deb0b862efd7c416ae6"
  head "https://github.com/sanger-pathogens/snp-sites.git"

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
