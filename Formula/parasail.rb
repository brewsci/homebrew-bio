class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/releases/download/v2.2/parasail-2.2.0.tar.gz"
  sha256 "8e75b32027017c891d6a84bb69ae83b0fe7d55253dd1c72a90946fb8fd15b374"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "56654603399ca71fd04761e9410d2762cd69c70999d14ba37ef07a4791bf3991" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # macos build error: https://github.com/brewsci/homebrew-bio/pull/464
  depends_on :linux

  if OS.mac?
    depends_on "gcc" # needs openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "gap_extend", shell_output("#{bin}/parasail_aligner 2>&1", 1)
    assert_match "Missing", shell_output("#{bin}/parasail_stats 2>&1", 1)
  end
end
