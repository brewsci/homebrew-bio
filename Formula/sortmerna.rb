class Sortmerna < Formula
  # cite Kopylova_2012: "http://doi.org/10.1093/bioinformatics/bts611"
  desc "SortMeRNA: filter metatranscriptomic ribosomal RNA"
  homepage "https://bioinfo.lifl.fr/RNA/sortmerna/"
  url "https://github.com/biocore/sortmerna/archive/v3.0.3.tar.gz"
  sha256 "76caf1f3891e62fb7ed4d233dcd039473c2d6a8506d5ffd74179e18dcd09690e"
  head "https://github.com/biocore/sortmerna.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "aa26fd0b1316228b17fcb700bab6a2121af7806435c1657c9cbbf8724ce1f47d" => :sierra
    sha256 "b412dde11f5cb06f8c4a1aa3d78719d0647ffe5a2e9ff81df960903346269bd1" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?
  depends_on "rapidjson"
  depends_on "rocksdb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "sortmerna"
    end
  end

  test do
    system "#{bin}/sortmerna", "--version"
  end
end
