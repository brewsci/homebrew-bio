class Hyphy < Formula
  desc "Hypothesis testing with phylogenies"
  homepage "http://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.63.tar.gz"
  sha256 "86a94a601fa136443a8cd69f61e3a47b1dc85f10743d317715b1e433278e9ee0"
  head "https://github.com/veg/hyphy.git"
  # tag "bioinformatics"

  option "with-opencl", "Build a version with OpenCL GPU/CPU acceleration"
  option "without-multi-threaded", "Don't build a multi-threaded version"
  option "without-single-threaded", "Don't build a single-threaded version"
  deprecated_option "with-mpi" => "with-open-mpi"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "open-mpi" => :optional

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make", "SP" if build.with? "single-threaded"
    system "make", "MP2" if build.with? "multi-threaded"
    system "make", "MPI" if build.with? "open-mpi"
    system "make", "OCL" if build.with? "opencl"
    system "make", "GTEST"

    system "make", "install"
    libexec.install "HYPHYGTEST"
    doc.install("help")
  end

  def caveats
    <<~EOS
      The help has been installed to #{doc}/hyphy.
    EOS
  end

  test do
    system libexec/"HYPHYGTEST"
  end
end

__END__
