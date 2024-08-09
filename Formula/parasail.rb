class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "9057041db8e1cde76678f649420b85054650414e5de9ea84ee268756c7ea4b4b"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "697ebb74c10b475e4aad54d39af9eb9f0dceb1e243df8a901172519b07e4cd0f"
    sha256 cellar: :any, x86_64_linux: "03f04da7fd392eddf775532f8bd7211689ad482c5f29e68a0f972b6c9bbe7c84"
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
