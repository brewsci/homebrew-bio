class Vcfexpress < Formula
  desc "Filter and format VCF/BCF with Lua expressions"
  homepage "https://github.com/brentp/vcfexpress"
  url "https://github.com/brentp/vcfexpress/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "f60b7d2eeccff4ce923a73ebdaa5e48200f2bcdfdbe15d17391c5c08a9b9cde3"
  license "MIT"
  head "https://github.com/brentp/vcfexpress.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "14421603221eb60857c5fd9a784b2570c964456aebd3fe7169892dfd3afe9865"
    sha256 cellar: :any, arm64_sequoia: "8b0c7f5d2a6289a0a342c6d96150f728f905c357e5788eaa910c51ac96963a21"
    sha256 cellar: :any, arm64_sonoma:  "8bb6f1fdae42881d48506f584ef34c0207e9463572843fbcecb72fa7db823a60"
    sha256 cellar: :any, x86_64_linux:  "a9b0a5702d906dce70023600481fe8e926c080acd47318f0283de166065a8c70"
  end

  # rust-htslib builds a bundled, static htslib
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcfexpress --version 2>&1")
    assert_match "expression", shell_output("#{bin}/vcfexpress --help 2>&1")
  end
end
