class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/archive/v2.4.2.tar.gz"
  sha256 "3843055fc04743269cf22d127ae26952a7f5e6fc4f1bc29f6b6f3c156c8ca434"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "697ebb74c10b475e4aad54d39af9eb9f0dceb1e243df8a901172519b07e4cd0f" => :catalina
    sha256 "03f04da7fd392eddf775532f8bd7211689ad482c5f29e68a0f972b6c9bbe7c84" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  if OS.mac?
    depends_on "gcc" # needs openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules", "--disable-dependency-tracking"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "gap_extend", shell_output("#{bin}/parasail_aligner -h 2>&1", 1)
    assert_match "Missing", shell_output("#{bin}/parasail_stats 2>&1", 1)
  end
end
