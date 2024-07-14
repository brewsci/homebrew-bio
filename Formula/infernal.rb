class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/infernal/infernal-1.1.5.tar.gz"
  sha256 "ad4ddae02f924ca7c85bc8c4a79c9f875af8df96aeb726702fa985cbe752497f"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5c56694194bb015695910aaa8937b66066d52cfb73ec1164e95956419e35830d"
    sha256 cellar: :any_skip_relocation, ventura:      "cea100f2dc5cf8bc05c5a891f04a0232d85aec6b756069f358c9c658ce4693a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34fbc91c80b970caacdbe787a23c34d4152cc358c2fd96d57521dba1bb80a675"
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
