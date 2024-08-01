class Reduce < Formula
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.14.tar.gz"
  version "4.14"
  sha256 "62e61cce221fff76b5834031302d91fe703a19945a42e16620d4fb860604daf4"
  license "BSD-4-Clause-UC"

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "python"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/reduce -version 2>&1", 2)
    assert_match "version 4.14", output
  end
end
