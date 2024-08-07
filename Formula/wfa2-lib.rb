class Wfa2Lib < Formula
  # cite Marco-Sola_2020: "https://doi.org/10.1093/bioinformatics/btaa777"
  # cite Marco-Sola_2023: "https://doi.org/10.1093/bioinformatics/btad074"
  desc "WFA-lib: Wavefront alignment algorithm library v2"
  homepage "https://github.com/smarco/WFA2-lib"
  url "https://github.com/smarco/WFA2-lib/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "2609d5f267f4dd91dce1776385b5a24a2f1aa625ac844ce0c3571c69178afe6e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "4ded90bfd98b912ccd50f14518a45e43c992f4d47345d43fd4140fc1bdfe23c3"
    sha256 cellar: :any,                 ventura:      "7c9e4326a339dc71d42f7119386c542c712b09883f188fcd09b30c2d75b7b324"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "649043ab1dd5f5591e501dd6f5aba145276db07664cea4d0a40f5484304e5a8d"
  end

  depends_on "bindgen" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    # rpath setting is necessary to avoid an error
    args = %W[
      -DOPENMP=TRUE
      -DCMAKE_INSTALL_RPATH=#{loader_path}
    ]
    args << "-DEXTRA_FLAGS=\"-ftree-vectorizer-verbose\"" if OS.mac? && Hardware::CPU.arm?
    system "cmake", ".", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install %w[examples img scripts tests tools]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <bindings/cpp/WFAligner.hpp>

      using namespace wfa;
      using namespace std;

      int main() {
          WFAlignerGapAffine aligner(4, 6, 2, WFAligner::Alignment, WFAligner::MemoryHigh);
          // Align two sequences (in this case, given as strings).
          string pattern = "TCTTTACTCGCGCGTTGGAGAAATACAATAGT";
          string text = "TCTATACTGCGCGTTTGGAGAAATAAAATAGT";
          aligner.alignEnd2End(pattern, text); // Align
          string cigar = aligner.getAlignment();
          cout << "CIGAR: " << cigar << endl;
          cout << "Alignment score: " << aligner.getAlignmentScore() << endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lwfa2", "-lwfa2cpp", "-I#{include}/wfa2lib",
                    "-L#{lib}"
    assert_match "Alignment score: -24", shell_output("./test")
  end
end
