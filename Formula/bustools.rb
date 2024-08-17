class Bustools < Formula
  # cite Melsted_2021: "https://doi.org/10.1038/s41587-021-00870-2"
  desc "Tools for working with BUS files"
  homepage "https://github.com/BUStools/bustools"
  url "https://github.com/BUStools/bustools/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "ad5816152644ee615316daecf5883183994bd7cc96e6c008439123f4cd750b1f"
  license "BSD-2-Clause"
  head "https://github.com/BUStools/bustools.git", branch: "master"

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "test/test_cases"
  end

  test do
    system "#{bin}/bustools", "fromtext",
           "-o", "#{testpath}/tc2mid.bus", "#{prefix}/test_cases/tc0002CollapseInput.txt"
    system "#{bin}/bustools", "collapse", "-o", "#{testpath}/tc2mid2", "-t", "#{prefix}/test_cases/transcripts.txt",
           "-g", "#{prefix}/test_cases/transcripts_to_genes.txt", "-e", "#{prefix}/test_cases/matrix.ec",
           "#{testpath}/tc2mid.bus"
    system "#{bin}/bustools", "text", "-o", "#{testpath}/tc0002output.txt", "#{testpath}/tc2mid2.bus"
    cmd = "diff -w -B -s #{prefix}/test_cases/tc0002ExpResult.txt #{testpath}/tc0002output.txt"
    assert_match "identical", shell_output(cmd)
  end
end
