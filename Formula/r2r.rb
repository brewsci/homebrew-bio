class R2r < Formula
  # cite Weinberg_2011: "https://doi.org/10.1186/1471-2105-12-3"
  desc "Software to speed depiction of aesthetic consensus RNA secondary structures"
  homepage "https://sourceforge.net/projects/weinberg-r2r"
  url "https://downloads.sourceforge.net/project/weinberg-r2r/R2R-1.0.6.tgz"
  sha256 "1ba8f51db92866ebe1aeb3c056f17489bceefe2f67c5c0bbdfbddc0eee17743d"

  depends_on "nlopt"
  def install
    system "./configure", "--enable-nlopt",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"
    system "make", "install"
    
    doc.install "R2R-manual.pdf"
  end

  test do
    assert_match version.to_s shell_output("#{bin}/r2r --version")
  end
end
