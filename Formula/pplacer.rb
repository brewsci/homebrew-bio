class Pplacer < Formula
  # cite Matsen_2010: "https://doi.org/10.1186/1471-2105-11-538"
  desc "Place query sequences on a fixed reference phylogenetic tree"
  homepage "http://matsen.fredhutch.org/pplacer/"
  url "https://github.com/matsen/pplacer/archive/refs/tags/v1.1.alpha20.tar.gz"
  sha256 "f88b4f0bf460d08e040e7178b5327c305f9b707af5e15b0522cdf6f2d5268ee5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "13badd77ed8e61808da91529f3dfd5fe30d8437cd8531ec4461ae73b89952b65"
    sha256 cellar: :any, arm64_sequoia: "d321ab0ff15acc3774b9ebb96fa9d068d30347004dd0f1f885e3da5f29d8961d"
    sha256 cellar: :any, arm64_sonoma:  "bf7221aadb3c9c0c20e7d996613faaebc22284c19fd66a83babb4424e5a879ba"
    sha256               x86_64_linux:  "1cc519a4f4ce88c6e3a41b6901f00e5ef341569983649d2518873b90175eba6c"
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkgconf" => :build
  depends_on "gsl"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  resource "mcl" do
    url "https://github.com/fhcrc/mcl/archive/b1f7a969371d434eaa6848bdbb79a851de617c1f.tar.gz"
    sha256 "9736fb693bc5eb4ec9fb26d300eaa656ea20744febe15efb98cd39699d2ff33b"
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing"
    system "opam", "repo", "add", "pplacer-deps", "http://matsen.github.io/pplacer-opam-repository"
    system "opam", "update"
    system "opam", "install", "--assume-depexts", "-y",
           "dune", "csv", "ounit2", "xmlm", "batteries", "gsl", "sqlite3", "camlzip", "ocamlfind"

    (buildpath/"mcl").install resource("mcl")
    inreplace "mcl/src/shmx/mcxclcf.c", "#include \"mcx.h\"",
                                        "#include \"mcx.h\"\n#include \"impala/app.h\""
    cd "mcl" do
      system "./configure"
      system "opam", "exec", "make"
    end
    system "opam", "exec", "dune", "build"
    cd "_build/default" do
      bin.install "pplacer.exe" => "pplacer"
      bin.install "guppy.exe" => "guppy"
      bin.install "rppr.exe" => "rppr"
    end
  end

  test do
    assert_match "pplacer [options]", shell_output("#{bin}/pplacer -help")
    assert_match "to_csv [options]", shell_output("#{bin}/guppy to_csv --help")
    assert_match "check -c my", shell_output("#{bin}/rppr check --help")
  end
end
