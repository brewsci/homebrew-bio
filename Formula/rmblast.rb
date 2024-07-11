class Rmblast < Formula
  desc "RepeatMasker compatible version of the standard NCBI BLAST suite"
  homepage "https://www.repeatmasker.org/rmblast/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.14.1/ncbi-blast-2.14.1+-src.tar.gz"
  version "2.14.1"
  sha256 "712c2dbdf0fb13cc1c2d4f4ef5dd1ce4b06c3b57e96dfea8f23e6e99f5b1650e"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sonoma: "598e95cfa3296e63d9a572e1c774c0b83b7c82f2c667d64c81750c85ee72b23e"
    sha256 ventura:      "c7406153055695416f4026cca69829f35154d080c5e82427e16c1d745f9dfd0e"
    sha256 x86_64_linux: "df884375c110e6920697fa0faa075bbe3b316790d48c99c244d6117dc84ff52f"
  end

  keg_only "rmblast conflicts with blast"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lmdb"
  depends_on "sqlite"
  depends_on "zstd"

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
      inreplace "src/build-system/configure", "-flat_namespace", ""
      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
        --without-boost
        --with-mt
        --without-debug
        --without-krb5
        --without-openssl
        --with-experimental=Int8GI
        --with-projects=scripts/projects/rmblastn/project.lst
      ]

      if OS.mac?
        # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
        args << "--with-sse42" if Hardware::CPU.intel? && MacOS.version.requires_sse42?
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
