class Plink2 < Formula
  # cite Chang_2015: "https://doi.org/10.1186/s13742-015-0047-8"
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/b15c19f.tar.gz"
  version "1.90b5"
  sha256 "e00ef16ac5abeb6b4c4d77846bd655fafc62669fbebf8cd2e941f07b3111907e"
  head "https://github.com/chrchang/plink-ng.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "5c6ac77111c1eeeab30af40e8a1c14391a182a10e2535f9ebe0a58ee62f70828"
    sha256 cellar: :any, x86_64_linux: "23f851b712db8ddf8e5587623b12599833c288aca026fa4790ee5384f0a870ba"
  end

  depends_on "openblas"
  uses_from_macos "zlib"

  def install
    cd "1.9" do
      system "make", "-f", "Makefile.std", "plink",
        "BLASFLAGS=-L#{Formula["openblas"].opt_lib} -lopenblas",
        "CFLAGS=-flax-vector-conversions",
        "CPPFLAGS=-DDYNAMIC_ZLIB -I#{Formula["openblas"].opt_include}",
        "ZLIB=-L#{Formula["zlib"].opt_lib} -lz"
      bin.install "plink" => "plink2"
    end
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert_predicate testpath/"dummy_cc1.bed", :exist?
  end
end
