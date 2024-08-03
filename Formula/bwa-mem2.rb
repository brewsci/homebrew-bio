class BwaMem2 < Formula
  desc "Next version of bwa-mem short read aligner"
  homepage "https://github.com/bwa-mem2/bwa-mem2"
  url "https://github.com/bwa-mem2/bwa-mem2.git",
      tag:      "v2.2.1",
      revision: "bf3d376e95f4321b0d37a27d7ff1c77da4d289ff"
  head "https://github.com/bwa-mem2/bwa-mem2.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ccaf67262f2f7e7f711d6f482ad004161c66aef0c55cadcb7ec4907a228f074d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "943583113491f963bd0e8460994ec17a95f19208a62b07a8d514d18e648ddf7d"
  end

  depends_on "cmake" => :build
  depends_on "dos2unix" => :build
  uses_from_macos "zlib"

  resource "sse2neon" do
    url "https://raw.githubusercontent.com/DLTcollab/sse2neon/v1.7.0/sse2neon.h"
    sha256 "c36e1355c1a22d9c3357c945d1ef8bd005cb1f0f7b378e6577a45ea96931a083"
  end

  resource "safestringlib" do
    url "https://github.com/intel/safestringlib/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "3f16492460eb6dc40fc63f4a1c018e7e32db9db65b86a1294aa6c3bf1e31310e"
  end

  resource "patch" do
    url "https://gist.githubusercontent.com/YoshitakaMo/eb6e6df7a621a9c9737bcc9363cf9bfc/raw/5936f4884daac3c961c6c9a62d9a0c676f578bbb/fastmap.patch"
    sha256 "cbba705412b8a1139be752759490606a988eee0483a3c0ee65aa0a03c1c9c9e8"
  end

  resource "patch2" do
    url "https://gist.githubusercontent.com/YoshitakaMo/c4cabc8e1e4b618047507bc354dbb51e/raw/1265ecf70a976476bd3e55d06804b94f9969310e/bandedSWA.cpp.patch"
    sha256 "cdc13b153a23beb890d258eeb41d13aa0b777c1747bdefa49c399634c176cda7"
  end

  def install
    # patch for fastmap.cpp
    system "dos2unix", "src/fastmap.cpp"
    system "dos2unix", "src/bandedSWA.cpp"
    buildpath.install resource("patch")
    buildpath.install resource("patch2")
    system "patch", "-p1", "src/fastmap.cpp", "fastmap.patch"
    system "patch", "-p1", "src/bandedSWA.cpp", "bandedSWA.cpp.patch"
    # patch for src/utils.h to fix build error
    # https://aur.archlinux.org/cgit/aur.git/tree/gcc_rdtsc.patch?h=bwa-mem2
    inreplace "src/utils.h", "defined(__GNUC__) && !defined(__clang__)",
                             "defined(__GNUC__) &&  __GNUC__ < 11 && !defined(__clang__)"
    # install safestringlib v1.2.0 first
    (buildpath/"safestringlib-1.2.0").install resource("safestringlib")
    cd "safestringlib-1.2.0" do
      inreplace "makefile", "LDFLAGS=-z noexecstack -z relo -z now", "LDFLAGS="
      inreplace "CMakeLists.txt", " -z noexecstack -z relro -z now", ""
      inreplace "include/safe_mem_lib.h", "extern errno_t memset_s", "//xxx extern errno_t memset_s"
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"safestringlib")
      system "cmake", "--build", "build"
    end
    inreplace "Makefile" do |s|
      s.gsub! "SAFE_STR_LIB=    ext/safestringlib/libsafestring.a",
              "SAFE_STR_LIB= safestringlib-1.2.0/build/libsafestring_static.a"
      s.gsub! "-Iext/safestringlib/include",
              "-Isafestringlib-1.2.0/include"
    end

    # use sse2neon for Apple Silicon
    if OS.mac? && Hardware::CPU.arm?
      (buildpath/"src").install resource("sse2neon")
      inreplace "src/sse2neon.h", "FORCE_INLINE uint64_t _rdtsc(void)", "FORCE_INLINE uint64_t __rdtsc(void)"
      inreplace ["src/FMI_search.h", "src/kswv.h", "src/bandedSWA.h"] do |s|
        s.gsub! "#include <immintrin.h>", "#include \"sse2neon.h\""
      end
      inreplace ["src/ksw.h", "src/ksw.cpp"] do |s|
        s.gsub! "#include <emmintrin.h>", "#include \"sse2neon.h\""
      end
      inreplace "src/bandedSWA.h", "#include <smmintrin.h>", "#include \"sse2neon.h\""
    end

    # fix
    inreplace "Makefile", "-Lext/safestringlib -lsafestring",
                          "-Lsafestringlib-1.2.0/build/ -lsafestring_static"
    inreplace "Makefile", "-Lext/safestringlib/ -lsafestring",
                          "-Lsafestringlib-1.2.0/build/ -lsafestring_static"
    inreplace "src/FMI_search.cpp" do |s|
      s.gsub! "_mm_prefetch((const char *)", "_mm_prefetch(reinterpret_cast<const char*>"
      s.gsub! "_mm_prefetch(&sa_ls_word[pos >> SA_COMPX]",
              "_mm_prefetch(reinterpret_cast<const char*>(&sa_ls_word[pos >> SA_COMPX])"
      s.gsub! "_mm_prefetch(&sa_ms_byte[pos >> SA_COMPX]",
              "_mm_prefetch(reinterpret_cast<const char*>(&sa_ms_byte[pos >> SA_COMPX])"
      s.gsub! "_mm_prefetch(&sa_ls_word[sp >> SA_COMPX]",
              "_mm_prefetch(reinterpret_cast<const char*>(&sa_ls_word[sp >> SA_COMPX])"
      s.gsub! "_mm_prefetch(&sa_ms_byte[sp >> SA_COMPX]",
              "_mm_prefetch(reinterpret_cast<const char*>(&sa_ms_byte[sp >> SA_COMPX])"
      s.gsub! "_mm_prefetch(&cp_occ[occ_id_pp_]",
              "_mm_prefetch(reinterpret_cast<const char*>(&cp_occ[occ_id_pp_])"
    end
    inreplace "src/bwamem.cpp" do |s|
      s.gsub! "__m512i zero512 = _mm512_setzero_si512()", "__m128i zero128 = _mm_setzero_si128();"
      s.gsub! "_mm512_store_si512((__m512i *)(hist + i), zero512)", "_mm_store_si128((__m128i *)(hist + i), zero128)"
    end
    inreplace "ext/safestringlib/safeclib/safeclib_private.h",
              "#include \"safe_lib.h\"", "#include <safe_lib.h>"

    # include FETK installed in the prefix directory
    cflags = "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    arch = OS.mac? ? "native" : "avx2"
    system "make", "arch=#{arch}", "CFLAGS=#{cflags}"
    bin.install "bwa-mem2"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bwa-mem2 version 2>&1")
  end
end
