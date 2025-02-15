class Bustools < Formula
  # cite Melsted_2021: "https://doi.org/10.1038/s41587-021-00870-2"
  desc "Tools for working with BUS files"
  homepage "https://github.com/BUStools/bustools"
  url "https://github.com/BUStools/bustools/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "e9a12be416d5d3940dd0ec3bfb0be3a481f2eea7d4411df1ab24c814332d99b8"
  license "BSD-2-Clause"
  head "https://github.com/BUStools/bustools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a565e30ad847ae81c9c8a998193d91f8025c10aaca218b6c7e51c998db9d16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09499bb96bb4eea55e28b20720992b6832e9bfc21d202875c7da2ebe5c896afb"
    sha256 cellar: :any_skip_relocation, ventura:       "e01ea0c4d743a64e8f460cc204c7233681c9c1c302d4116d0f745d72d944b2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744516aab838192ebefb49baca7110bda35161035dce6158c10a617ac150da18"
  end

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
