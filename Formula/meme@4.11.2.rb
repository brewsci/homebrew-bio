class MemeAT4112 < Formula
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  desc "Tools for motif discovery"
  homepage "https://meme-suite.org"
  url "https://meme-suite.org/meme/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"
  license :cannot_represent
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_sequoia: "8db59f0f29d2d3ce627b82b5d31a566df74bce3beadfb82a1f5d8ab1d43c1863"
    sha256 arm64_sonoma:  "d16beb26a003552d274cde0e3154b0022dd5cf706f0e638f2fc246333f9144db"
    sha256 ventura:       "d5edb62bc514dd71be4223edbb8f38fea1342f128fd7bc1476457acfd8044e03"
    sha256 x86_64_linux:  "31bb379cd8af341c30765c509cf7af2f3f985f0ce1b8ed2b3bc53a96f2d9481b"
  end

  depends_on "ghostscript"
  depends_on "open-mpi"
  depends_on "python@3.12"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
    sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  end

  def install
    ENV.append "CFLAGS", "-fcommon -fgnu89-inline"
    ENV.append "LDFLAGS", "-Wl,--allow-multiple-definition" if OS.linux?
    inreplace "src/mast.h", "#include <sys/types.h>\n", "#include <sys/types.h>\n#include <sys/wait.h>\n"

    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      perl_resources = %w[XML::Parser]
      perl_resources.each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-mpidir=#{Formula["open-mpi"].opt_prefix}",
      "--with-url=https://meme-suite.org/meme",
      "--with-python3=#{Formula["python@3.12"].opt_bin}/python3",
      "--with-gs=#{Formula["ghostscript"].opt_bin}/gs"

    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?
    pkgshare.install "tests/common/At.s"
  end

  test do
    system bin/"meme", pkgshare/"At.s"
  end
end
