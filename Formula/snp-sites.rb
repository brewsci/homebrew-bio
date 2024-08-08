class SnpSites < Formula
  # cite Page_2016: "https://doi.org/10.1099/mgen.0.000056"
  desc "Find SNP sites in a multi FASTA alignment file"
  homepage "https://github.com/sanger-pathogens/snp-sites"
  url "https://github.com/sanger-pathogens/snp-sites/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "913f79302e5d3127aea382756abc9ffeb05e26ce00022f43a6ea16a55cdd7a7e"
  revision 1
  head "https://github.com/sanger-pathogens/snp-sites.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "c3747d156344b5ce2404ed8096faccc98ea748a3d9e35971dfb04b38f4832f33"
    sha256 cellar: :any,                 ventura:      "8091b0451723403cf1984a6323c500bca0c3547241bcbdcd50e3054e649e2121"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c43b7263b98270d9db37b5a7ad334396ab0bd804956e020c7410f9d8181431e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snp-sites -V 2>&1")
  end
end
