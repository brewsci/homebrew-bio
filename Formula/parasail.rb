class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "9057041db8e1cde76678f649420b85054650414e5de9ea84ee268756c7ea4b4b"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "d33b9922b04448b1db43b257d7bc38a62dfd3f16ee4071c8d605ba6b143db4c5"
    sha256 cellar: :any,                 arm64_sequoia: "7c194a8470069d80b40c2d49b6ac8e12fbaa7744bba863a2500ed34abb043417"
    sha256 cellar: :any,                 arm64_sonoma:  "46519846cb725dc5e0fa79265e48d9c0b557d643f1b7abf4c6a842fc72984b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d429793e35de58f3b11f7a4c705e67984e3d8254d4e381d8d7d0597b28303be7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.linux?
      inreplace "tests/test_verify_traces.c" do |s|
        s.gsub! "ref_trace_table = parasail_result", "ref_trace_table = (int8_t *)parasail_result"
        s.gsub! "size_a, size_b, ref_trace_table, trace_table",
                "size_a, size_b, (int8_t *)ref_trace_table, (int8_t *)trace_table"
      end
    end
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make", "check"
    system "make", "install"
    prefix.install "tests"
  end

  test do
    assert_match "gap_extend", shell_output("#{bin}/parasail_aligner -h 2>&1", 1)
    assert_match "Missing", shell_output("#{bin}/parasail_stats 2>&1", 1)
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <parasail.h>
      #include <parasail/matrices/blosum62.h>
      #include <parasail/matrices/pam50.h>

      int main(int argc, char ** argv)
      {
          int major = 0;
          int minor = 0;
          int patch = 0;
          parasail_result_t *result = NULL;
          parasail_matrix_t *matrix = NULL;
          parasail_profile_t *profile = NULL;

          parasail_version(&major, &minor, &patch);
          printf("parasail is using C lib version %d.%d.%d", major, minor, patch);
          result = parasail_sw("asdf", 4, "asdf", 4, 10, 1, &parasail_blosum62);
          printf("result->score = %d", result->score);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lparasail", "-I#{include}", "-L#{lib}"
    assert_match "result->score = 20", shell_output("./test")
  end
end
