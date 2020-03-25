class Nanopolish < Formula
  # cite Loman_2015: "https://doi.org/10.1038/nmeth.3444"
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
      :tag      => "v0.12.0",
      :revision => "6a1333c0106e0969a13ed8fc40153c18e8da4790"
  head "https://github.com/jts/nanopolish.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "96585ee4d83de6848fcb18f15499b07bc90bb3b1dec358aa1040d307d2c64df3" => :catalina
    sha256 "024891195b39013008a3a2d03946617697602335077d36930e975091232ca8b8" => :x86_64_linux
  end

  depends_on "eigen" => :build # static link
  depends_on "wget" => :build

  depends_on "gcc" if OS.mac? # needs openmp
  depends_on "hdf5"
  depends_on "htslib"
  depends_on "python@3.8" # for scripts

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    # remove this when 0.12.1 comes out
    # https://github.com/jts/nanopolish/commit/466c63d24896084535e8072e20d0aabc981a9888
    inreplace "src/nanopolish_call_methylation.cpp", "<omp.h>", " <omp.h>\n#include <zlib.h>"

    system "make", "EIGEN=1", "HDF5=1", "HTS=1", "EIGEN_INCLUDE=-I#{Formula["eigen"].opt_include}/eigen3"
    prefix.install "scripts", "nanopolish"
    bin.install_symlink "../nanopolish"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanopolish --version")
    assert_match "extracted 1 read",
                 shell_output("#{bin}/nanopolish extract -o out.fasta \
                    #{pkgshare}/test/data/LomanLabz_PC_Ecoli_K12_R7.3_2549_1_ch8_file30_strand.fast5 2>&1")
    assert_match ">channel_8_read_24", File.read("out.fasta")
  end
end
