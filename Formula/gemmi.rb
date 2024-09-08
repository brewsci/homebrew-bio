class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "f3dd7c3aac0b01f0338ff5034c11be0e7b23639f018c8d6b1db7cc9d77a8dee9"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "df0daef4176f1ce790ff7a1bf349bc3bc921ca8bc4b37e0afc38bb3bbfd4b5d2"
    sha256 cellar: :any,                 ventura:      "513e849c601230133509089f870084b68529dbe23d8c924e7e491bddf9998075"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "57514a5ae5d24a2d546056a336a6ab035bfbc399ac0d9abfbd4d6ab4f26bb330"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/project-gemmi/gemmi/master/tests/5i55.cif"
    sha256 "cae937745acc22d1c3bdd21cc6fa3c36a3d9f271494c22e3e3a3ce512c72fb1d"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-testdata").stage testpath/"example"
    assert_match "_atom_site.B_iso_or_equiv\t1\t218", shell_output("#{bin}/gemmi tags example/5i55.cif")
  end
end
