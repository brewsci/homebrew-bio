class Dida < Formula
  # cite Mohamadi_2015: "https://doi.org/10.1371/journal.pone.0126409"
  desc "Distributed Indexing Dispatched Alignment"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/dida"

  url "http://www.bcgsc.ca/platform/bioinfo/software/dida/releases/1.0.1/dida-1.0.1.tar.gz"
  sha256 "251d8b6d40d061eb7a7c49737a1ce41592b89a6c8647a791fb9d64ff26afd7bd"
  revision 2

  fails_with :clang # needs openmp

  # Fix error: DIDA must be compiled with MPI support.
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end
  depends_on "open-mpi"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dida-wrapper --help 2>&1")
  end
end
