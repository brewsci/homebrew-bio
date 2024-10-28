class Hyphy < Formula
  desc "Hypothesis testing with phylogenies"
  homepage "http://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.63.tar.gz"
  sha256 "86a94a601fa136443a8cd69f61e3a47b1dc85f10743d317715b1e433278e9ee0"
  head "https://github.com/veg/hyphy.git"
  # tag "bioinformatics"

  deprecated_option "with-mpi" => "with-open-mpi"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "open-mpi" => :optional

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make", "hyphy"
    system "make", "MPI" if build.with? "open-mpi"

    system "make", "install"
  end

  def caveats
    <<~EOS
      The help has been installed to #{doc}/hyphy.
    EOS
  end
  
end

__END__
