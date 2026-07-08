class R2r < Formula
  # cite Weinberg_2011: "https://doi.org/10.1186/1471-2105-12-3"
  desc "Software to speed depiction of aesthetic consensus RNA secondary structures"
  homepage "https://sourceforge.net/projects/weinberg-r2r/"
  url "https://downloads.sourceforge.net/project/weinberg-r2r/R2R-1.0.7.tgz"
  sha256 "b18d26e27b84d022a59bb5cb33d0670fb5cc6245ce40808b2ef2fc9f8e968b61"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "a4ad8532873cf38876d39dc09307d8df5d38c24449a05d66acf5d8e4aa857be8"
    sha256 cellar: :any, x86_64_linux: "4b2d4f909b7c0041838e6a53e70be2dcfafbbf97bdd4a1460e6c9b987a7fae7a"
  end

  depends_on "nlopt"

  def install
    system "./configure", "--enable-nlopt",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"
    system "make", "install"
    doc.install "R2R-manual.pdf"
    # R2R_Stockholm.pm is a Perl module, not an executable; keep it out of bin
    libexec.install bin/"R2R_Stockholm.pm"
    inreplace bin/"SelectSubFamilyFromStockholm.pl",
              "use lib $Bin;", "use lib \"#{libexec}\";"
  end

  test do
    assert_match "version", shell_output("#{bin}/r2r --version")
  end
end
