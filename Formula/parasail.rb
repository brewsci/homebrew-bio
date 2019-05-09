class Parasail < Formula
  # Daily_2016: "https://doi.org/10.1186/s12859-016-0930-z"
  desc "Pairwise Sequence Alignment Library"
  homepage "https://github.com/jeffdaily/parasail"
  url "https://github.com/jeffdaily/parasail/archive/v2.4.1.tar.gz"
  sha256 "a0cffa81251151d1038c89ec8c5105d2c4234b88d240015fee0244e26c2a739f"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "65765b5cdbd7df279b53531510747a729c6e0f8ab0fbaf6fbf3dd2df2bb96525" => :sierra
    sha256 "8bec7c43ed7c68786b0af4d4ededf42caf78899d6bfd2ccae7a9dae9d0356ebb" => :x86_64_linux
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
