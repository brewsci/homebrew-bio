class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "9057041db8e1cde76678f649420b85054650414e5de9ea84ee268756c7ea4b4b"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "faeab0fcabddb2c01aa4074c33fdd0dd25741ecb0926cee06ca7cbdae0326446"
    sha256 cellar: :any,                 ventura:      "ff35f0aeacce8b24808147f6b8e37698976bde5fd3f2ec583e8c93fa69429214"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6338c1b45986fcc9cd499dfd4dbf265468a759f747d25d6adbb7a9177c9f120"
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
        s.gsub! "size_a, size_b, ref_trace_table", "size_a, size_b, (int8_t *)ref_trace_table"
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
