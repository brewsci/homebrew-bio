class Libgff < Formula
  desc "Ligntweight C++ library for parsing GFF/GTF files"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/v2.0.0.tar.gz"
  sha256 "7656b19459a7ca7d2fd0fcec4f2e0fd0deec1b4f39c703a114e8f4c22d82a99c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fe14582a9d6be713cae7378e060d5d91408449aeea98ba720754a491beed8cda" => :catalina
    sha256 "b313f0cd8a8532ba0c330bfc22a11e4cbbfb21dad02f400934e87fd48e4a8482" => :x86_64_linux
  end

  depends_on "cmake" => :build

  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate lib/"libgff.a", :exist?
    assert_predicate include/"gff.h", :exist?
  end
end
