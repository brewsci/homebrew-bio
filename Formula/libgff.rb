class Libgff < Formula
  desc "Ligntweight C++ library for parsing GFF/GTF files"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/v1.2.tar.gz"
  sha256 "bfabf143da828e8db251104341b934458c19d3e3c592d418d228de42becf98eb"

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
