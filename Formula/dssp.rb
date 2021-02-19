class Dssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  # cite Kabsch_1983: "https://doi.org/10.1002/bip.360221211"
  desc "Create DSSP files"
  homepage "https://github.com/cmbi/dssp"
  url "https://github.com/cmbi/dssp/archive/3.1.4.tar.gz"
  sha256 "496282b4b5defc55d111190ab9f1b615a9574a2f090e7cf5444521c747b272d4"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "6ebb2d6959f7db323d0645e964ccdbc20a666bf9579aea4673291f06ed3ace82"
    sha256 cellar: :any, x86_64_linux: "f838bdac491bd122ee73017146a2840f0ddcd450b38e9ac72c158365aa1e9a73"
  end

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
