class Swipe < Formula
  # Rognes 2011: "https://doi.org/10.1186/1471-2105-12-221"
  desc "Smith-Waterman database searches with inter-sequence SIMD parallelisation"
  homepage "https://github.com/torognes/swipe"
  url "https://github.com/torognes/swipe/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "537337bb3a61ff6a2e92f695d561df170f8593a4b9c4d5f21b3a884b16c24c65"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "04d5c4e737d41d1fca5d8b848d3bfdfac96e9c7defeeae73fcb5ad40944ff439"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe6052456ecb3759d84019038262b07bff3a665ed114d73b614275220728d3c0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "bashcompdir=#{bash_completion}", "zshcompdir=#{zsh_completion}"
  end

  test do
    assert_match "SWIPE #{version}", shell_output("#{bin}/swipe --version")
  end
end
