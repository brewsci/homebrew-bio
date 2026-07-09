class RustSasa < Formula
  desc "Ludicrously fast CLI for calculating protein SASA written in Rust"
  homepage "https://github.com/maxall41/RustSASA"
  url "https://github.com/maxall41/RustSASA/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "2f2d7509d2e2bb3a9c1cf79d1b53d6bc1c6de2693ae7d8494a637ab136fadcae"
  license "MIT"
  head "https://github.com/maxall41/RustSASA.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73719270ba4488c7d9be2d66c05c8f42ea26a4ad6c07dd709402ecc31d38dafb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7f67b779d1387c70982daded786a532f9525aaffd58a08288186c0ed7e1a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f52598e6423682f268377f31c086573842aaaf2dca130b266f5031d04011641"
    sha256 cellar: :any,                 x86_64_linux:  "442241d89b4b1c03190254620bd4cd9d13d38e9d7038033228b81d8f6e5f3b36"
  end

  depends_on "rust" => :build

  resource "pdbtbx" do
    url "https://github.com/maxall41/pdbtbx/archive/332d29a232755e28c20d12929f9fea72be958e4c.tar.gz"
    sha256 "1b4af990e399d265582c23af5f4fea757f89842de8be92c92beb6af676484455"
  end

  def install
    resource("pdbtbx").stage(buildpath/"pdbtbx")
    system "cargo", "install", "--features", "cli", *std_cargo_args
    pkgshare.install "tests/data/pdbs/example.cif"
  end

  test do
    assert_match "Usage: rust-sasa [OPTIONS] <INPUT> <OUTPUT>", shell_output("#{bin}/rust-sasa --help")
    shell_output("#{bin}/rust-sasa #{pkgshare}/example.cif #{testpath}/out.json")
    assert_path_exists testpath/"out.json"
    output = File.read(testpath/"out.json")
    assert_match '"value":220.10417,"name":"MET","is_polar":false', output
  end
end
