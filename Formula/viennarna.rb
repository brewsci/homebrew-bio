class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/~ronny/RNA/"
  url "https://www.tbi.univie.ac.at/RNA/packages/source/ViennaRNA-2.4.3.tar.gz"
  sha256 "4cda6e22029b34bb9f5375181562f69e4a780a89ead50fe952891835e9933ac0"

  fails_with :clang # needs OpenMP

  depends_on "gcc" if OS.mac? # for OpenMP
  depends_on "python@2"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-python",
      "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "-1.30 MEA=21.31", pipe_output("#{bin}/RNAfold --MEA", "CGACGUAGAUGCUAGCUGACUCGAUGC")
  end
end
