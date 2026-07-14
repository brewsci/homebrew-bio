class Oases < Formula
  # cite Schulz_2012: "https://doi.org/10.1093/bioinformatics/bts094"
  desc "De novo transcriptome assembler for very short reads"
  homepage "https://www.ebi.ac.uk/~zerbino/oases/"
  url "https://github.com/dzerbino/oases/archive/refs/tags/0.2.09.tar.gz"
  sha256 "7aad1195b3e5d88291150669acd9a32cc328df173d88697287f1c2b9da24d3bd"
  license "GPL-3.0"
  head "https://github.com/dzerbino/oases"

  livecheck do
    url :stable
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "79b961f7f73835ea2ae13a7312bfd84f18c0af317de31659a475e27048d946c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0efc1b966ea6e662d6994762b3d20d76d1278965e666fa7f06ccb25ac0d1053b"
  end

  depends_on "velvet"

  uses_from_macos "zlib"

  resource "velvet" do
    url "https://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz"
    sha256 "884dd488c2d12f1f89cdc530a266af5d3106965f21ab9149e8cb5c633c977640"
  end

  def install
    ENV.deparallelize

    resource("velvet").stage do
      mkdir buildpath/"velvet"
      cp_r ".", buildpath/"velvet"
    end

    args = ["LONGSEQUENCES=1", "CATEGORIES=2", "MAXKMERLENGTH=127"]
    args << "OPENMP=1" unless OS.mac?

    # The 0.2.09 Makefile already defaults to VELVET_DIR=velvet (our staged
    # resource) and no longer has a `doc` target, so no inreplaces are needed.
    system "make", *args

    bin.install "oases", "scripts/oases_pipeline.py"
  end

  test do
    assert_match "Zerbino", shell_output("#{bin}/oases 2>&1", 1)
    assert_match "KMERGE", shell_output("python2.7 #{bin}/oases_pipeline.py 2>&1", 1) if which "python2.7"
  end
end
