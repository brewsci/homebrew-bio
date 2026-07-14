class FinchRs < Formula
  # Bovee_2018: "https://doi.org/10.21105/joss.00505"
  desc "Genomic minhashing implementation in Rust"
  homepage "https://github.com/onecodex/finch-rs"
  # Build the Rust source instead of the prebuilt release binaries: upstream only
  # ever shipped x86_64 finch-mac64/finch-linux64 assets, which fail the
  # non-native-architecture audit on Apple Silicon runners.
  url "https://github.com/onecodex/finch-rs/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "bca7ce13bd588656f47316eb8bf4ee10321261f412ead339105713a7d154f438"
  license "MIT"

  # Newer releases ship only Python wheels (no standalone Rust source bumps we
  # can track cleanly), so pin 0.3.0 and skip autobump.
  livecheck do
    skip "upstream now ships Python wheels instead of standalone binaries"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "eca9f68be258523651b801b889a7535638b069ffe06d5608dc6171da192aacc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9e2bc391659d9e97baec72828d5c5d90ec5c991a3a6a0d80f17ec2b52732240"
  end

  depends_on "rust" => :build
  depends_on "xz"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/finch --version 2>&1")
  end
end
