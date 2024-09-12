class Mashmap < Formula
  desc "Fast approximate aligner for long DNA sequences"
  homepage "https://github.com/marbl/MashMap"
  url "https://github.com/marbl/MashMap/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "7719dd6b3c25e650e16218252eaae7dbf424a10890d717ec3ad0920b102fd05a"
  license :cannot_represent

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "htslib"
  depends_on "openblas"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "data", "scripts"
  end

  test do
    assert_match "Example usage", shell_output("#{bin}/mashmap -h 2>&1", 1)
    cmd = "#{bin}/mashmap -r #{prefix}/data/scerevisiae8.fa.gz " \
          "-q #{prefix}/data/scerevisiae8.fa.gz --pi 95 " \
          "-n 1 " \
          "-Y '#' " \
          "-o scerevisiae8.paf"
    system cmd
    assert_predicate testpath/"scerevisiae8.paf", :exist?
    assert_match "UWOPS034614#1#chrMT", (testpath/"scerevisiae8.paf").read
  end
end
