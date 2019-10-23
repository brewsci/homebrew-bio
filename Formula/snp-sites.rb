class SnpSites < Formula
  # cite Page_2016: "https://doi.org/10.1099/mgen.0.000056"
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/v2.5.1.tar.gz"
  sha256 "913f79302e5d3127aea382756abc9ffeb05e26ce00022f43a6ea16a55cdd7a7e"
  head "https://github.com/sanger-pathogens/snp-sites.git"

  bottle do
    cellar :any
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "68523d90936ce5ef3db15182579f159f298f3d6933b977854f7e5ef355cbaa3c" => :mojave
    sha256 "c0f1d36e106ae656720bcd6b90e3cff18c01b75c92cd36b2216c919ae0f33261" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "check" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

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
