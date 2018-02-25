class Racon < Formula
  # cite "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/files/741519/racon-v0.5.0.tar.gz"
  sha256 "298934749d5ce76be3645f62a5cc9194572bb62f5ba646c153df1dac2983e084"
  head "https://github.com/isovic/racon.git"

  needs :cxx11
  fails_with :clang # needs openmp

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install "bin/racon"
  end

  test do
    assert_match "Options", shell_output("#{bin}/racon 2>&1", 1)
  end
end
