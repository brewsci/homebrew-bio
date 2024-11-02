class Meme < Formula
  # cite Bailey_2006: "https://doi.org/10.1093/nar/gkl198"
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  # cite Bailey_2015: "https://doi.org/10.1093/nar/gkv416"
  desc "Motif-based sequence analysis tools"
  homepage "https://meme-suite.org"
  url "https://meme-suite.org/meme/meme-software/5.5.7/meme-5.5.7.tar.gz"
  sha256 "1dca8d0e6d1d36570c1a88ab8dbe7e4b177733fbbeacaa2e8c4674febf57aaf4"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "abb99fb2140558b2d5171314f3e491ab1e12dee65952d9384c36f90e65c2ad4a"
    sha256 arm64_sonoma:  "c4627d12c361852b0f99effd24213e6752d3cb5280e1b3d17c4fc47514fbcefb"
    sha256 ventura:       "3a0a4b3a24c9b5efd762a662ad3d39e277230f4761bde0346468538e5318fd9b"
    sha256 x86_64_linux:  "ad991b1efad6a110b553b932219357bd655a6396850ae33f7d6934c0c0c5f8eb"
  end

  depends_on "ghostscript"
  depends_on "open-mpi"
  depends_on "python@3.13"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  resource "XML::Parser" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
    sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  end

  def install
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
      "--with-python=#{Formula["python@3.13"].opt_bin}/python3",
      "--with-gs=#{Formula["ghostscript"].opt_bin}/gs"

    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?
    pkgshare.install "tests/common/At.s"
  end

  test do
    system bin/"meme", pkgshare/"At.s"
  end
end
