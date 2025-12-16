class RustSasa < Formula
  desc "Ludicrously fast CLI for calculating protein SASA written in Rust"
  homepage "https://github.com/maxall41/RustSASA"
  url "https://github.com/maxall41/RustSASA/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "649d73e07d67958641f3546f5874534cf13e43a19c1d729ba0e5fad562338bcc"
  license "MIT"
  head "https://github.com/maxall41/RustSASA.git", branch: "main"

  depends_on "rust" => :build

  resource "pdbtbx" do
    url "https://github.com/maxall41/pdbtbx/archive/332d29a232755e28c20d12929f9fea72be958e4c.tar.gz"
    sha256 "1b4af990e399d265582c23af5f4fea757f89842de8be92c92beb6af676484455"
  end

  def install
    resource("pdbtbx").stage(buildpath/"pdbtbx")
    system "cargo", "install", *std_cargo_args
    pkgshare.install "pdbs", "radii"
  end

  test do
    assert_match "Usage: rust-sasa [OPTIONS] <INPUT> <OUTPUT>", shell_output("#{bin}/rust-sasa --help")
    shell_output("#{bin}/rust-sasa #{pkgshare}/pdbs/example.cif #{testpath}/out.json")
    assert_path_exists testpath/"out.json"
    output = File.read(testpath/"out.json")
    assert_match '"value":222.80806,"name":"MET","is_polar":false', output
  end
end
