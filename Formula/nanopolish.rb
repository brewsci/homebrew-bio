class Nanopolish < Formula
  # cite Loman_2015: "https://doi.org/10.1038/nmeth.3444"
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
        :tag => "v0.9.0",
        :revision => "1c6ae110a1b7d0ca5072025b1889997fec0828ed"
  revision 1
  head "https://github.com/jts/nanopolish.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "fc037c77203e00cb96937cea83aa524c97af083ec051a3c7a28cc6bb666b7415" => :sierra_or_later
    sha256 "27bc64fe7504ef33c2463c41f7ee11807193368c4ac68d6f6575b037c3e83575" => :x86_64_linux
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
