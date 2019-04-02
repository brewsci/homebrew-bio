class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1101/565374"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.1.0.tar.gz"
  sha256 "8cb18a5049265c583955d8d638c8f390ce0664553695788e8f902718a7c31750"
  head "https://github.com/bcgsc/ntEdit.git"

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    inreplace "Makefile", "ntedit.cpp", "ntedit.cpp -lz"
    system "make"
    bin.install "ntedit"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntedit --help 2>&1")
  end
end
