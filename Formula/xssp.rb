class Xssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  desc "Create DSSP and HSSP files"
  homepage "https://github.com/cmbi/xssp"
  url "https://github.com/cmbi/xssp/archive/3.0.5.tar.gz"
  sha256 "fded09f08cfb12e578e4823295dc0d0aaeff6559d5e099df23c5bcc911597ccd"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "849f2d68b0544ae0ac3000c056d3808525a6d66ee53832983cf9be5ef555193a" => :sierra
    sha256 "4b5099b0040f734ea414ea38c0984590370cd12e8ced7bfc3c7ceddfab45e66c" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "bzip2" unless OS.mac?

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
