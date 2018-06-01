class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://lowelab.ucsc.edu/software/tRNAscan-SE-1.3.1.tar.gz"
  sha256 "862924d869453d1c111ba02f47d4cd86c7d6896ff5ec9e975f1858682282f316"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "2369259ea3db0f809510f646d0ea6e053fd964265609525f2567183f9d182fb7" => :sierra_or_later
    sha256 "9f4d534364839d479e5f14b04340214d0c9d4a7fe44d4c31dd155cc616bb6672" => :x86_64_linux
  end

  def install
    inreplace "tRNAscan-SE.src", "use strict;", "use strict;\nuse lib \"#{prefix}\";"
    system "make", "all", "install", "CFLAGS=-D_POSIX_C_SOURCE=1", "BINDIR=#{bin}", "LIBDIR=#{libexec}", "MANDIR=#{man}"
    prefix.install bin/"tRNAscanSE"
    prefix.install "Demo"
    (prefix/"Demo").install "testrun.ref"
  end

  test do
    system "#{bin}/tRNAscan-SE", "-d", "-y", "-o", "test.out", "#{prefix}/Demo/F22B7.fa"
    assert_predicate testpath/"test.out", :exist?
    assert_equal File.read("test.out"), File.read(prefix/"Demo/testrun.ref")
  end
end
