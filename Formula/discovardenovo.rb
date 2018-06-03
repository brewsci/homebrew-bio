class Discovardenovo < Formula
  desc "Large genome assembler"
  homepage "https://www.broadinstitute.org/software/discovar/blog/"
  url "ftp://ftp.broadinstitute.org/pub/crd/DiscovarDeNovo/latest_source_code/discovardenovo-52488.tar.gz"
  sha256 "445445a3b75e17e276a6119434f13784a5a661a9c7277f5e10f3b6b3b8ac5771"

  depends_on "gcc@4.9" => :build
  depends_on "jemalloc"

  # error: '::memchr' has not been declared
  depends_on :linux

  uses_from_macos "zlib"

  fails_with :clang # needs openmp
  # error: reference to 'align' is ambiguous
  fails_with :gcc => "5"

  def install
    # Fix for GCC 5 error: redeclaration of 'template<class TAG> void
    # Contains(const vec<T>&, kmer_id_t, vec<long int>&, bool, int)' may not
    # have default arguments [-fpermissive]
    ENV.append_to_cflags "-fpermissive"

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "DiscovarDeNovo r52488", shell_output("#{bin}/DiscovarDeNovo --version")
  end
end
