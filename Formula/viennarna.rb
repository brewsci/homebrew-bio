class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  url "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_4_x/ViennaRNA-2.4.17.tar.gz"
  sha256 "b1e608f6f37cdf4adbcdd1f86fd9ebfcc1e663d58488e0f8173a58879480c121"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any,                 catalina:     "4edf24ac8964ff748439cf211a3f3d4a34a51ef28d2429de42a607d451f2fd6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64232367b889c918417a97f8274fca437556e18d89ce227898a56516e5b977ea"
  end

  depends_on "gcc" if OS.mac? # needs openmp
  depends_on "perl"
  depends_on "python"

  fails_with :clang # needs openmp

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--without-python",
      "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "-1.30 MEA=21.31", pipe_output("#{bin}/RNAfold --MEA", "CGACGUAGAUGCUAGCUGACUCGAUGC")
  end
end
