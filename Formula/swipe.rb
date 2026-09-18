class Swipe < Formula
  # Rognes 2011: "https://doi.org/10.1186/1471-2105-12-221"
  desc "Smith-Waterman database searches with inter-sequence SIMD parallelisation"
  homepage "https://github.com/torognes/swipe"
  url "https://github.com/torognes/swipe/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "cc7cd65ddafd6b9e69975292bee0583bdf64918e8d5c7ddd98ae41a20d3f8b73"
  license "AGPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "04d5c4e737d41d1fca5d8b848d3bfdfac96e9c7defeeae73fcb5ad40944ff439"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe6052456ecb3759d84019038262b07bff3a665ed114d73b614275220728d3c0"
  end

  # swipe.h includes <x86intrin.h> and uses SSE intrinsics throughout; there is
  # no arm64/NEON code path, so it can only be built on x86_64.
  depends_on arch: :x86_64

  def install
    system "make", "swipe", "COMMON="
    bin.install "swipe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swipe -h version 2>&1", 1)
  end
end
