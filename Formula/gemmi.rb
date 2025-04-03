class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5d87c3e82ee159f5642d7c083a74e00ca9cc038ccf9be2522d7ae985f3377393"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "5c8bbcf90e2b91193d32f20103ef7386e8cf7def3ca80df5c0f912cfdb33097a"
    sha256 cellar: :any,                 arm64_sonoma:  "17d560afbc7d5f9b8bbd66e39597e1dc9d5b2ba32affaec24d81834742db9cc3"
    sha256 cellar: :any,                 ventura:       "91cd70d12c5a2ce13ff6a093c42db40e36a417a8d4f8f78f1be02a7f7e8be2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62657a88e65216d1dc89f9e18dd15aeb8e9773ca1576189d49091e115fc4bf5b"
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
