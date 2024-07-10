class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "722369495f7374bb938d14da2c3a9f8444b753e2d9536cf097c161a53dbbae19"
  license "MPL-2.0"

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
