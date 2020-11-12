class Xssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  desc "Create DSSP and HSSP files"
  homepage "https://github.com/cmbi/xssp"
  url "https://github.com/cmbi/xssp/releases/download/3.0.9/xssp-3.0.9.tar.gz"
  sha256 "42a9a93c48d22478212dcaf6ceb3feb64443e4cb2e8cccdd402b47a595d16658"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "c0833e3e3db899b28dd9515e1d3ffb791528d2934d25226dbf4eaf0f0428b34f" => :sierra
    sha256 "890f4a0285987df828d271ad333b597181358c75b65026d94dccf3d7c6d49531" => :x86_64_linux
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
