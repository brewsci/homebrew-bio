class Meme < Formula
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  desc "Tools for motif discovery"
  homepage "https://meme-suite.org"
  url "https://meme-suite.org/meme/meme-software/5.5.5/meme-5.5.5.tar.gz"
  sha256 "bebb4a176e72d62e3a2d5ba5f22439185bbc4bbf4769604fbca12dff8e1f739f"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 x86_64_linux: "b66235d3ce6851c700bc395dff15f2346234b6e84d750dd9d4d92945a999e01a"
  end

  depends_on "ghostscript"
  depends_on "open-mpi"
  depends_on "python@3.12"

  uses_from_macos "perl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_linux do
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
      sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
    end
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
      "--enable-web" \
      "--with-url=https://meme-suite.org/meme" \
      "--with-python=#{Formula["python@3.12"].opt_bin}/python3",
      "--with-gs=#{Formula["ghostscript"].opt_bin}/gs"

    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: ENV["PERL5LIB"] if OS.linux?
    pkgshare.install "tests/common/At.s"
  end

  test do
    system bin/"meme", pkgshare/"At.s"
  end
end
