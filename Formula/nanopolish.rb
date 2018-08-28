class Nanopolish < Formula
  # cite Loman_2015: "https://doi.org/10.1038/nmeth.3444"
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
        :tag => "v0.10.1",
        :revision => "0438b85dd3acf84a34c8e3d2098d55ab040900e3"
  head "https://github.com/jts/nanopolish.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "678a1c256882db603b6b022cf81bafadcf41b6ba5a4bba1ff71c6b963391c69a" => :sierra_or_later
    sha256 "602a855af633cd50210b1853482f1b8562bfb38f5042df99b65e697c3391f331" => :x86_64_linux
  end

  fails_with :clang # needs openmp
  needs :cxx11

  depends_on "eigen" => :build
  depends_on "hdf5"
  depends_on "htslib"
  depends_on "gcc" if OS.mac? # for openmp

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    # Use brewed eigen, hdf5, and htslib.
    system "make", "EIGEN=1", "HDF5=1", "HTS=1", "EIGEN_INCLUDE=-I#{Formula["eigen"].opt_include}/eigen3"
    prefix.install "scripts", "nanopolish"
    bin.install_symlink "../nanopolish"
    pkgshare.install "test"
  end

  test do
    assert_match "usage", shell_output("#{bin}/nanopolish --help")
    assert_match "extracted 1 read", shell_output("#{bin}/nanopolish extract -o out.fasta #{pkgshare}/test/data/LomanLabz_PC_Ecoli_K12_R7.3_2549_1_ch8_file30_strand.fast5 2>&1")
    assert_match ">channel_8_read_24", File.read("out.fasta")
  end
end
