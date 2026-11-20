class Swipe < Formula
  # Rognes 2011: "https://doi.org/10.1186/1471-2105-12-221"
  desc "Smith-Waterman database searches with inter-sequence SIMD parallelisation"
  homepage "https://github.com/torognes/swipe"
  url "https://github.com/torognes/swipe/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "537337bb3a61ff6a2e92f695d561df170f8593a4b9c4d5f21b3a884b16c24c65"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2faf59ff3637702d4b98750cba48199ee520e895a4ff15f18fbefbb77fe58f50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b122505acf6a2e486737fc0a2a53efd575d24e24a389634264a4be6fe48579e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6e872e3b0a9450d62df027e2f88175f8329d82b699c8aed8c30d6cd984cd23a"
    sha256 cellar: :any,                 x86_64_linux:      "83d0d8d34201aff98345018260123ab5533f3e438e44d0c632b94268de4344ca"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "bashcompdir=#{bash_completion}", "zshcompdir=#{zsh_completion}"
  end

  test do
    assert_match "SWIPE #{version}", shell_output("#{bin}/swipe --version")
  end
end
