class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/infernal/infernal-1.1.5.tar.gz"
  sha256 "ad4ddae02f924ca7c85bc8c4a79c9f875af8df96aeb726702fa985cbe752497f"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "90dde134e8db249856e3432376d4d5f8658f2a8abc2390beed3030908de03d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01baed72ace481f680194bec8c1df2e7f90282f8ba731412e92e8dcfc0ed17ad"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "tutorial", "matrices"
    doc.install Dir["documentation/*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/cmsearch #{pkgshare}/tutorial/minifam.cm #{pkgshare}/tutorial/mrum-tRNAs10.fa")
  end
end
