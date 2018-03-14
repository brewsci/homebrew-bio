class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler of a Bloom filter de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v2.0.7/minia-v2.0.7-Source.tar.gz"
  sha256 "76d96dc14b8c4c01e081da6359c3a8236edafc5ef93b288eaf25f324de65f3ce"

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    mkdir "build" do
      # Reduce memory usage for CircleCI.
      ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]
      args = std_cmake_args
      # Fix error: 'hdf5/hdf5.h' file not found
      args.delete "-DCMAKE_BUILD_TYPE=Release"
      args << "-DSKIP_DOC=1"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      # Resolve conflict with hdf5: https://github.com/GATB/minia/issues/5
      mv bin/"h5dump", bin/"minia-h5dump"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
