class MmtfCpp < Formula
  # cite Bradley_2017: "https://doi.org/10.1371/journal.pcbi.1005575"
  desc "The pure C++ implementation of the MMTF API, decoder and encoder"
  homepage "https://github.com/rcsb/mmtf-cpp"
  url "https://github.com/rcsb/mmtf-cpp/archive/v1.0.0.tar.gz"
  sha256 "881f69c4bb56605fa63fd5ca50842facc4947f686cbf678ad04930674d714f40"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8b39cff9ba4c472eed266632996266fdf4533c28600ee629ad4fe5b433dccca3" => :sierra
    sha256 "13fdd052921a4c7404dcb224c1dc426d8bf468349ddb401afb3d6932167ee3c5" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "msgpack"

  resource "173Dmmtf" do
    url "https://mmtf.rcsb.org/v1.0/full/173D.mmtf.gz"
    sha256 "5860449ba1c9faa04da183c413e607201f4c48370dee02e9f4af7e0d86408afa"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-G", "Ninja", *std_cmake_args
      system "ninja", "install"
    end
  end

  test do
    resource("173Dmmtf").stage do
      # Reference: https://github.com/rcsb/mmtf-cpp/README.md

      (testpath/"test.cpp").write <<~EOS
        #include <mmtf.hpp>
        int main(int argc, char** argv) {
          mmtf::StructureData data;
          mmtf::decodeFromFile(data, "./173D.mmtf");
          return 0;
        }
      EOS

      system ENV.cxx, "-o", "mmtftest", testpath/"test.cpp"
      system "./mmtftest"
    end
  end
end
