class Rmblast < Formula
  desc "RepeatMasker compatible version of the standard NCBI BLAST suite"
  homepage "https://www.repeatmasker.org/rmblast/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.14.1/ncbi-blast-2.14.1+-src.tar.gz"
  version "2.14.1"
  sha256 "712c2dbdf0fb13cc1c2d4f4ef5dd1ce4b06c3b57e96dfea8f23e6e99f5b1650e"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 big_sur:      "168462e3c3a8e41bffed4f1e8c644209fc507c6f97096b0b8665a5a16b65b0c0"
    sha256 x86_64_linux: "c5023c4da86fd2573fbcfe8dae72384840e84c3d12fd3a8c569818b01446c081"
  end

  keg_only "rmblast conflicts with blast"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lmdb"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  fails_with gcc: "5" # C++17

  patch do
    url "https://www.repeatmasker.org/rmblast/isb-2.14.1+-rmblast.patch.gz"
    sha256 "9c8091eb2aec97ac83287859d2bfec83cb08c082d5a121cbefe3cc626f933763"
  end

  def install
    cd "c++" do
      # Fix -flat_namespace being used on Big Sur and later.
      inreplace "src/build-system/configure", "-flat_namespace", "" if MacOS.version >= :big_sur
      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --without-boost
        --with-mt
        --without-debug
        --without-krb5
        --without-openssl
        --with-experimental=Int8GI
        --with-projects=scripts/projects/rmblastn/project.lst
      ]
      # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
      args << "--with-sse42" if Hardware::CPU.intel? && MacOS.version.requires_sse42?

      if OS.mac?
        args += ["OPENMP_FLAGS=-Xpreprocessor -fopenmp",
                 "LDFLAGS=-lomp"]
      end

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rmblastn -help")
  end
end
