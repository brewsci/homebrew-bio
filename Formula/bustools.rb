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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a17a828141b0a2b1a0551b4122bf55f9954bf9146cb88b4b5782baffc3f0077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d23834ca12eb84d52a35c873fd9093226c5a8fc3b590b5ce80237f4577e0bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27931d55293900b770d2ef58b99092ca6ddc6d82fe3647b181eff97d3b457dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4796497271be61a04973a0cee5d5957e6ffbd2cacd5b6cd63371c74ded3327a"
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
