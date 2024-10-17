class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "f3dd7c3aac0b01f0338ff5034c11be0e7b23639f018c8d6b1db7cc9d77a8dee9"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "139cb8e147d28a1512bdb5f969d6a5c7b554b436793f320e03bcb5d928b91410"
    sha256 cellar: :any,                 ventura:      "5b7e78ceb9b8aa202556f3a4f4e535067d0dbaa70c9fb03739eb3a975f70d77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "37203084f8b234ae310692fd91713888f04719837bfcce6fc47df8ae387c0b02"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/project-gemmi/gemmi/master/tests/5i55.cif"
      sha256 "cae937745acc22d1c3bdd21cc6fa3c36a3d9f271494c22e3e3a3ce512c72fb1d"
    end
    resource("homebrew-testdata").stage testpath/"example"
    assert_match "_atom_site.B_iso_or_equiv\t1\t218", shell_output("#{bin}/gemmi tags example/5i55.cif")
  end
end
