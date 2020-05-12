class R2r < Formula
  # cite Weinberg_2011: "https://doi.org/10.1186/1471-2105-12-3"
  desc "Software to speed depiction of aesthetic consensus RNA secondary structures"
  homepage "https://sourceforge.net/projects/weinberg-r2r"
  url "https://downloads.sourceforge.net/project/weinberg-r2r/R2R-1.0.6.tgz"
  sha256 "1ba8f51db92866ebe1aeb3c056f17489bceefe2f67c5c0bbdfbddc0eee17743d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a4ad8532873cf38876d39dc09307d8df5d38c24449a05d66acf5d8e4aa857be8" => :catalina
    sha256 "4b2d4f909b7c0041838e6a53e70be2dcfafbbf97bdd4a1460e6c9b987a7fae7a" => :x86_64_linux
  end

  depends_on "nlopt"
  def install
    system "./configure", "--enable-nlopt",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"
    system "make", "install"
    doc.install "R2R-manual.pdf"
  end

  test do
    assert_match "version", shell_output("#{bin}/r2r --version")
  end
end
