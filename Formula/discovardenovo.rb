class Discovardenovo < Formula
  desc "Large genome assembler"
  homepage "https://www.broadinstitute.org/software/discovar/blog/"
  url "ftp://ftp.broadinstitute.org/pub/crd/DiscovarDeNovo/latest_source_code/discovardenovo-52488.tar.gz"
  sha256 "445445a3b75e17e276a6119434f13784a5a661a9c7277f5e10f3b6b3b8ac5771"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ff015936c5bf261b15066451482245f60eece7fb14b385664374883cad1f1a36" => :x86_64_linux
  end

  depends_on "gcc@4.9" => :build
  depends_on "jemalloc"

  # error: invalid use of incomplete type 'struct Serializability<long long int>'
  depends_on :linux

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  # error: reference to 'align' is ambiguous
  fails_with :gcc => "5"

  # error: could not convert 'kmer_shape_zebra<K>::getStringId()'
  # from 'String' {aka 'FeudalString<char>'} to 'KmerShapeId'
  fails_with :gcc => "9"

  def install
    # Fix for case insensitive file systems. error: '::memchr' has not been declared
    mv "src/String.h", "src/CharString.h"
    inreplace Dir["src/**/*.{cc,h}"], '#include "String.h"', '#include "CharString.h"', false

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
