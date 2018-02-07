class Fastani < Formula
  desc "Fast Whole-Genome Similarity (ANI) Estimation"
  homepage "https://github.com/ParBLiSS/FastANI"
  url "https://github.com/ParBLiSS/FastANI/archive/v1.0.tar.gz"
  sha256 "36f35211f2f4dc02b4e250af7c40c5f616d30239f5ef7aa366cdec65075a7db7"
  head "https://github.com/ParBLiSS/FastANI.git"
  # cite "https://doi.org/10.1101/225342"

  depends_on "zlib" unless OS.mac?
  depends_on "autoconf" => :build
  depends_on "gsl"
  depends_on "boost"

  def install
    system "autoconf"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-gsl=#{Formula["gsl"].opt_prefix}",
      "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "fragments", shell_output("#{bin}/fastANI --help 2>&1", 1)
  end
end
