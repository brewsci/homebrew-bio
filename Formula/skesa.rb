class Skesa < Formula
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/"
  url "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/skesa.2.2.updated_README.tar.gz"
  version "2.2.1"
  sha256 "402905876e4bb2556614eb247c436d23d1c5dec4a83577918243bbd38d734797"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "252a040d1184b30c08dccea18cd6b34400b60cf1d241307d9a6e85ed329247b5" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    makefile = "Makefile.nongs"

    # https://github.com/ncbi/SKESA/issues/6
    if OS.mac?
      inreplace makefile, "-Wl,-Bstatic", ""
      inreplace makefile, "-Wl,-Bdynamic -lrt", ""
    end

    system "make", "-f", makefile, "BOOST_PATH=#{Formula["boost"].opt_prefix}"
    bin.install "skesa"
    doc.install "README.skesa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skesa --version 2>&1")
  end
end
