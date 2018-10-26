class Exonerate < Formula
  # cite Slater_2005: "https://doi.org/10.1186/1471-2105-6-31"
  desc "Pairwise sequence alignment of DNA and proteins"
  homepage "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
  url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.2.0.tar.gz"
  sha256 "0ea2720b1388fa329f889522f43029b416ae311f57b229129a65e779616fe5ff"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "da5d8b8ba78eaa5e5c9f02b6116d1a354543a69cc612e4aecd0030efaf32ddc3" => :sierra
    sha256 "ffc9dc069931c451df43d67dc0ed5b21f45594c942564eda789eac9b5002293e" => :x86_64_linux
  end

  devel do
    url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.4.0.tar.gz"
    sha256 "f849261dc7c97ef1f15f222e955b0d3daf994ec13c9db7766f1ac7e77baa4042"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    # Fix the following error. This issue is fixed upstream in 2.4.0.
    # /usr/bin/ld: socket.o: undefined reference to symbol 'pthread_create@@GLIBC_2.2.5'
    # /lib/x86_64-linux-gnu/libpthread.so.0: error adding symbols: DSO missing from command line
    inreplace "configure", 'LDFLAGS="$LDFLAGS -lpthread"', 'LIBS="$LIBS -lpthread"' unless build.devel?

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Examples", shell_output("#{bin}/exonerate --help", 1)
  end
end
