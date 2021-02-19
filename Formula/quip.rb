class Quip < Formula
  # cite Jones_2012: "https://doi.org/10.1093/nar/gks754"
  desc "Compressing NGS data with extreme prejudice"
  homepage "https://homes.cs.washington.edu/~dcjones/quip"
  url "https://homes.cs.washington.edu/~dcjones/quip/quip-1.1.8.tar.gz"
  sha256 "525c697cc239a2f44ea493a3f17dda61ba40f83d7c583003673af9de44775a64"
  license "BSD-3-Clause"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, sierra:       "1a135241904594960e9f95f79459aa9e9260c68825619b3e364c11bb6520a87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17808a8e7ed851868d7db36563cc7a3665a87a8516a87fdd10bba2feee18aa07"
  end

  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quip --version 2>&1")
  end
end
