class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7673b005846c661196dd49ac23bac3b1acc07b3afbdaff0e5d7f0f19b491e8c4"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "87dcf82d3254502c9560b737c419e94182916276f946da401f742941d96485a9"
    sha256 cellar: :any,                 arm64_sonoma:  "4ceb61df72d4ff5466f49101613328503a42554d55a4d5f2ceb10fe470601274"
    sha256 cellar: :any,                 ventura:       "f4960fa0b5819ede57a7a0e693e2d92f330fc0b2a7accc7b630a6c7f630361e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98edc90619397d84640a0b3c6e29c6abadec90a9e2f76d2194bc3fa88a6eac6"
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
