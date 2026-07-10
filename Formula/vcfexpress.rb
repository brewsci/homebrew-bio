class Vcfexpress < Formula
  desc "Filter and format VCF/BCF with Lua expressions"
  homepage "https://github.com/brentp/vcfexpress"
  url "https://github.com/brentp/vcfexpress/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "f60b7d2eeccff4ce923a73ebdaa5e48200f2bcdfdbe15d17391c5c08a9b9cde3"
  license "MIT"
  head "https://github.com/brentp/vcfexpress.git", branch: "main"

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
