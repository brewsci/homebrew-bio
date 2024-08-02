class Reduce < Formula
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.14.tar.gz"
  sha256 "62e61cce221fff76b5834031302d91fe703a19945a42e16620d4fb860604daf4"
  license "BSD-4-Clause-UC"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "python@3.12"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end

    output = shell_output(bin/"reduce -Version 2>&1", 2)
    assert_match "reduce.4.14.230914", output
    resource("homebrew-testdata").stage testpath
    system("#{bin}/reduce -NOFLIP -Quiet 3qug.pdb > 3qug_h.pdb")
    assert_match "add=1902, rem=0, adj=62", File.read("3qug_h.pdb")
  end
end
