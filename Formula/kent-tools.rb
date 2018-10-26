class KentTools < Formula
  desc "Utilities for the UCSC Genome Browser"
  homepage "https://genome.ucsc.edu/"
  url "http://hgdownload.soe.ucsc.edu/admin/exe/userApps.v367.src.tgz"
  sha256 "dea0d6d9f8011f6212c196b26f0549c5c09268abf179a444fec674304e70f460"
  head "git://genome-source.cse.ucsc.edu/kent.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "efad1b89d2d833d7f57e835a7ae4abe5725a997e80202faabaaf6903d351bf01" => :x86_64_linux
    sha256 "9caec5fc38f9552f2569550c88a816735dda7fefc05335795e09dd4923a0473d" => :sierra
  end

  depends_on "libpng"
  depends_on "mysql@5.7"
  depends_on "openssl"
  unless OS.mac?
    depends_on "rsync"
    depends_on "util-linux"
    depends_on "zlib"
  end

  def install
    libpng = Formula["libpng"]
    mysql = Formula["mysql@5.7"]

    args = ["userApps", "BINDIR=#{bin}", "SCRIPTS=#{bin}"]
    args << "MACHTYPE=#{`uname -m`.chomp}"
    args << "PNGLIB=-L#{libpng.opt_lib} -lpng -lz"
    args << "PNGINCL=-I#{libpng.opt_include}"
    args << "MYSQLINC=#{mysql.opt_include}/mysql"
    args << "MYSQLLIBS=-lmysqlclient -lz"

    cd build.head? ? "src" : "kent/src" do
      inreplace "parasol/makefile", "DESTDIR=${HOME}/bin", ""
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
