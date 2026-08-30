class Libgff < Formula
  desc "Ligntweight C++ library for parsing GFF/GTF files"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "96d2bda64aaf9cf7b6c1a42205e408b0ef2a353ba42dad560db215e7ec105e2e"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61cb05dd029d65d00961b92044202453b2ba03912a7468be01450798dc2183ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "858aa9e199f72d9ec3de25417534773d4d3c0b468f4bd705ccf7edb5bd7ce7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6399aeab645551e8d795f827e58676a7d6f49599d31432a31b5b5424bc3ced4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22a102754f1ba7630f5ac84ab9acc4a1a4a4c9466e298f472cce3b32ea5fc439"
  end

  depends_on "cmake" => :build

  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_path_exists lib/"libgff.a"
    assert_path_exists include/"gff.h"
  end
end
