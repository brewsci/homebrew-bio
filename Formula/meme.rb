class Meme < Formula
  # cite Bailey_2006: "https://doi.org/10.1093/nar/gkl198"
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  # cite Bailey_2015: "https://doi.org/10.1093/nar/gkv416"
  desc "Motif-based sequence analysis tools"
  homepage "https://meme-suite.org"
  url "https://meme-suite.org/meme/meme-software/5.5.8/meme-5.5.8.tar.gz"
  sha256 "1b4a1753795c09b1d46de6c4a3f04b33c1bcc3e41bbcf4e6e14220e8ad76743b"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "bdfe73064b8bd5baad09e93498dbcb7fbdfa9a19cd25837e83b07d427eb4fb29"
    sha256 arm64_sequoia: "1ff51eb17a94e46aad51b83b919023873b249b465bc28befcd752d1ee56761a6"
    sha256 arm64_sonoma:  "c5b6e3ce882ab09998ae2c104a6b4ca34da76710beebc342ebff6b2f4d0d2a07"
    sha256 x86_64_linux:  "5572caec25810afbe31c3715cc09ab938c1ac08f8230b2f401172134806ebed2"
  end

  depends_on "ghostscript"
  depends_on "open-mpi"
  depends_on "python@3.14"

  uses_from_macos "expat"
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
      "--with-python=#{Formula["python@3.14"].opt_bin}/python3",
      "--with-gs=#{Formula["ghostscript"].opt_bin}/gs"

    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?
    pkgshare.install "tests/common/At.s"
  end

  test do
    system bin/"meme", pkgshare/"At.s"
  end
end
