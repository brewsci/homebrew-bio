class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/infernal/infernal-1.1.5.tar.gz"
  sha256 "ad4ddae02f924ca7c85bc8c4a79c9f875af8df96aeb726702fa985cbe752497f"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2aa2c65ee7b9cc98226bae551897406d34abf9739aec2e36e1e17b0ca04798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55dd988f9ce52f02fa375625ad107e80ded9e9798b709e65b7eaf768200c4b64"
    sha256 cellar: :any_skip_relocation, ventura:       "928a3daa94efa21d8bdebe5828037c37cae97c7e46db317088b4d4f56c1123ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f95d029d98bebb284149240f6437ae08030e34ffabcb0b8969bdf4fe287e9a"
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
