class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/infernal/infernal-1.1.5.tar.gz"
  sha256 "ad4ddae02f924ca7c85bc8c4a79c9f875af8df96aeb726702fa985cbe752497f"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c1bbc13442b5f7ae9908c4f274f67b6b0a38bb3b5b0be5447b9bad9ce5c7716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b45e096ad08fbcd16007d55e5f55249efa2d5d8d0e5d715756e9e18e66ff94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5411e72d195993f3ed9d00dc6a4cabfaee0272d25faa1c163e9ca10398ef164f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9351ccc8fbfbd703dfde77bb4ce2350b1ec94f74dc8c489ab02d12eb753a4fb"
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
