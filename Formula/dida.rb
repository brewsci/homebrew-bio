class Dida < Formula
  # cite Mohamadi_2015: "https://doi.org/10.1371/journal.pone.0126409"
  desc "Distributed Indexing Dispatched Alignment"
  homepage "https://www.bcgsc.ca/platform/bioinfo/software/dida"

  url "https://www.bcgsc.ca/platform/bioinfo/software/dida/releases/1.0.1/dida-1.0.1.tar.gz"
  sha256 "251d8b6d40d061eb7a7c49737a1ce41592b89a6c8647a791fb9d64ff26afd7bd"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "be712df11ffeb8d647d62e68d38209cd1e90494ea5227ff6c8f35d08cdfd13d9"
    sha256 x86_64_linux: "be67b9e1b268441b1ded890789aa081ee133f1c532ac3145c423726f2a96a44e"
  end

  depends_on "open-mpi"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc" # needs openmp
  end

  fails_with :clang # needs openmp

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
