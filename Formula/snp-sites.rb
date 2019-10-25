class SnpSites < Formula
  # cite Page_2016: "https://doi.org/10.1099/mgen.0.000056"
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/v2.5.1.tar.gz"
  sha256 "913f79302e5d3127aea382756abc9ffeb05e26ce00022f43a6ea16a55cdd7a7e"
  head "https://github.com/sanger-pathogens/snp-sites.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a9e5aa1f834835b9eeb9645a6cc4e6b730287754182c54abc55542fe39ef398a" => :mojave
    sha256 "7395080925bfacc38ca0e7a3f16dc5f824d18b2505a96ce12016c50a36147915" => :x86_64_linux
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
