class Reduce < Formula
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.15.tar.gz"
  sha256 "f2f993e3f86ded38135d6433e0a7c2ed10fbe5da37f232c04d7316702582ed06"
  license "BSD-4-Clause-UC"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "123d1d666fcc44ff484c293d287e913e8b23c98158e96c9d49447b7cf510eb93"
    sha256 cellar: :any_skip_relocation, ventura:      "d3d14773905e8bffad53ed565510b514c571e0eadba77a3157a37a435a8bb83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0aa39a9f1f020a4f294fa8fdf6cf68a214313095e15847559ef842cea9aa41df"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  def install
    # Refer to https://github.com/rlabduke/reduce/issues/60 for `-DHET_DICTIONARY` and `-DHET_DICTOLD` flags
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
      "-DHET_DICTIONARY=#{prefix}/reduce_wwPDB_het_dict.txt",
      "-DHET_DICTOLD=#{prefix}/reduce_get_dict.txt"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end

    output = shell_output(bin/"reduce -Version 2>&1", 2)
    assert_match "reduce.4.15.250408", output
    resource("homebrew-testdata").stage testpath
    system("#{bin}/reduce -NOFLIP -Quiet 3qug.pdb > 3qug_h.pdb")
    assert_match "add=1902, rem=0, adj=62", File.read("3qug_h.pdb")
  end
end
