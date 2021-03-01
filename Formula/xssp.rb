class Xssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  desc "Create DSSP and HSSP files"
  homepage "https://github.com/cmbi/xssp"
  url "https://github.com/cmbi/xssp/releases/download/3.0.10/xssp-3.0.10.tar.gz"
  sha256 "b475d6fa62098df0e54c8dbdaa0b32de93bf5a393335f73f9b5a7e95f3090d2a"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "da26ad34a5cb1fdff5cb02392d988b64e9141739e143567faa340eda2224e0c1"
    sha256 cellar: :any, x86_64_linux: "e5c633a52565607cedbbe1d0d14255ecdc56deeb4401b6a7ea823baf09639006"
  end

  deprecate! because: "has been replaced by brewsci/bio/dssp and brewsci/bio/hssp"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  uses_from_macos "bzip2"

  resource "pdb" do
    url "https://files.rcsb.org/download/3ZZZ.pdb.gz"
    sha256 "9c3dfd81b7bf2f991f69dd1de0df5ea16eaa6d050409b65bfbe2d1a5ad44c11a"
  end

  # This formula does not contain libzeep.
  # If libzeep is not detected, then `mkhssp --fetch-dbrefs` is disabled.
  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
           "--with-boost=#{Formula["boost"].opt_prefix}"

    system "make"
    system "make", "install"
  end

  test do
    resource("pdb").stage do
      system bin/"mkdssp", "-i", "3zzz.pdb", "-o", testpath/"test.dssp"
    end
    assert_match "POLYPYRIMIDINE", (testpath/"test.dssp").read
  end
end
