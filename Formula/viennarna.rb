class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  url "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_4_x/ViennaRNA-2.4.14.tar.gz"
  sha256 "ba9cfc8a48e457fc891628f3229a3924de31714460dc4a4dec081868f802cc28"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "545e5d7602b62cbe670b203e62e37dced68254007c3f730e0119c6d74a3faddf" => :catalina
    sha256 "d76e232d798fdd980cb5a7abac2dcd0c40f70b71923abf4cb1ce92fbe3e04638" => :x86_64_linux
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
