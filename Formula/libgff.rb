class Libgff < Formula
  desc "Ligntweight C++ library for parsing GFF/GTF files"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "96d2bda64aaf9cf7b6c1a42205e408b0ef2a353ba42dad560db215e7ec105e2e"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "fe14582a9d6be713cae7378e060d5d91408449aeea98ba720754a491beed8cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b313f0cd8a8532ba0c330bfc22a11e4cbbfb21dad02f400934e87fd48e4a8482"
  end

  depends_on "cmake" => :build

  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_path_exists lib/"libgff.a"
    assert_path_exists include/"gff.h"
  end
end
