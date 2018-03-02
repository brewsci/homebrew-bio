class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "https://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v358.src.tgz"
  sha256 "d888abbf83f2b2c7c58b96556360ea1728518aa85d83e5724d94c2132e1dee9f"
  head "git://genome-source.cse.ucsc.edu/kent.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "04b38d218eb87829f33baae42d453b872aa2de986a330754445b2fc12d60fb93" => :high_sierra
    sha256 "2b2faf1a428b99541c20dc4136c8ea6d6f4832607364478e537c278baeb4f676" => :sierra
    sha256 "6bf095413b6aa2de56551c51a81273ced85efae0b59905492fccdbc08e7d2b8c" => :el_capitan
  end

  depends_on "libpng"
  depends_on "mysql"
  depends_on "openssl"
  depends_on "util-linux" unless OS.mac?
  depends_on "zlib" unless OS.mac?

  def install
    libpng = Formula["libpng"]
    mysql = Formula["mysql"]

    args = ["userApps", "BINDIR=#{bin}", "SCRIPTS=#{bin}"]
    args << "MACHTYPE=#{`uname -m`.chomp}"
    args << "PNGLIB=-L#{libpng.opt_lib} -lpng -lz"
    args << "PNGINCL=-I#{libpng.opt_include}"

    # On Linux, depends_on :mysql looks at system MySQL so check if Homebrew
    # MySQL already exists. If it does, then link against that. Otherwise, let
    # kent-tools link against system MySQL (see kent/src/inc/common.mk)
    if mysql.installed?
      args << "MYSQLINC=#{mysql.opt_include}/mysql"
      args << "MYSQLLIBS=-lmysqlclient -lz"
    end

    cd build.head? ? "src" : "kent/src" do
      system "make", *args
    end

    cd bin do
      blat_bin = %w[blat faToTwoBit gfClient gfServer nibFrag pslPretty
                    pslReps pslSort twoBitInfo twoBitToFa]
      rm blat_bin
      mv "calc", "kent-tools-calc"
    end
  end

  def caveats; <<~EOS
    The `calc` tool has been renamed to `kent-tools-calc`.

    This only installs the standalone tools located at
      http://hgdownload.cse.ucsc.edu/admin/exe/

    If you need the full UCSC Genome Browser, run:
      brew install ucsc-genome-browser

    This does not install the BLAT tools. To install BLAT:
      brew install blat
    EOS
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >test
      ACTG
    EOS
    system "#{bin}/faOneRecord test.fa test > out.fa"
    compare_file "test.fa", "out.fa"
  end
end
