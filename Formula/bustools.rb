class Bustools < Formula
  # cite Melsted_2021: "https://doi.org/10.1038/s41587-021-00870-2"
  desc "Tools for working with BUS files"
  homepage "https://github.com/BUStools/bustools"
  url "https://github.com/BUStools/bustools/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "d6b3ce8c700335aa10e28421da1edcedd3efa55e8390dd2729ff1d43ead0e642"
  license "BSD-2-Clause"
  head "https://github.com/BUStools/bustools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5242c48c6515a4b90500131bc4f1890174502c462fecea778a7c607b6d1a9d10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22092c34a9eba596a0989866fa14336a138c055f3eefed4c7644bbc250d87eed"
    sha256 cellar: :any_skip_relocation, ventura:       "5c773d80e31c62c57061f13ac4a6f4699e2c8fd0b897068ab941133826abd798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef453ec8ae2716c1d43d1289c0e96112dc71070db238454666a00d7bc721a5d"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
