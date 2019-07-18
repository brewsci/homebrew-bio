class Nanopolish < Formula
  # cite Loman_2015: "https://doi.org/10.1038/nmeth.3444"
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
      :tag      => "v0.11.1",
      :revision => "ee82bf51c8e12f330da13ef6de888e6fba20e722"
  head "https://github.com/jts/nanopolish.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "778bc9ee1ca72935495e31a5a6c7f95168c9f62b4c20476ee056b5699d56b568" => :sierra
    sha256 "cf71c24e7a3f7e5ee30a1cbba8a6a65ba3bd8e3bcca3cb35630272ecef925079" => :x86_64_linux
  end

  depends_on "eigen" => :build
  depends_on "gcc" if OS.mac? # for openmp
  depends_on "hdf5"
  depends_on "htslib"

  fails_with :clang # needs openmp

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
    assert_match "extracted 1 read",
                 shell_output("#{bin}/nanopolish extract -o out.fasta #{pkgshare}/test/data/LomanLabz_PC_Ecoli_K12_R7.3_2549_1_ch8_file30_strand.fast5 2>&1")
    assert_match ">channel_8_read_24", File.read("out.fasta")
  end
end
