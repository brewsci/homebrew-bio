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
    sha256 cellar: :any_skip_relocation, catalina:     "e6479d546058d193564ba724fec92872a997403816db0476d0d5b12d5659b2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b85086e6c5714775f2311f7647c571e97057ab761de0aada0afc2f0a8af5e9d7"
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
