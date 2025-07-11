class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ed5e1d0665f27d623d877fa36f6c99a5de21310cc8715337ff9f6b545bd2e9d3"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "8213f3d71755b64716e0b2a41dfa6be1cb354354328268f8ce6c7811fe03d610"
    sha256 cellar: :any,                 arm64_sonoma:  "214d556e428d48069f273e04beab7199b9e04f0c24f555e1a3837aec2a558f6c"
    sha256 cellar: :any,                 ventura:       "c2c0f416a48d60fa9e48d8bbb17e4a3f0846710906e35af42f1a8b3a560855b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763b99321bcfbcf0a120cdf2295202416759c7ddefd7034b1b2f933739e2618e"
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
