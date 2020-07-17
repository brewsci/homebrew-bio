class Libgff < Formula
  desc "Ligntweight C++ library for parsing GFF/GTF files"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/v2.0.0.tar.gz"
  sha256 "7656b19459a7ca7d2fd0fcec4f2e0fd0deec1b4f39c703a114e8f4c22d82a99c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "78123ff254fdc3d3ed58582038a35bf7d8c1e2499457853a6707ec5a148c1c2d" => :catalina
    sha256 "007cdbede758b7ff0836073ec6c7991bdeb24f84027310957e735e6aea0ce8b5" => :x86_64_linux
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
