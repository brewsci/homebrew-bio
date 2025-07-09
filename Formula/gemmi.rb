class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ed5e1d0665f27d623d877fa36f6c99a5de21310cc8715337ff9f6b545bd2e9d3"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "e07b324a6c9fd2334442ad256df033d8f1fa8f346c6844efee1c4aa3532bcbcf"
    sha256 cellar: :any,                 arm64_sonoma:  "f82aee40865363bcc3dadc60952ddcac488ab70b93dd5430e10539ec679726a6"
    sha256 cellar: :any,                 ventura:       "e5b06ecace456cb8fd75332315fac0f1bace4673e4447ab00e3698ce361d9725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e804773699d35214ad11dea0e5e2ef3862ef3fa9ff2b37d4dbd39ae8d9107d"
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
