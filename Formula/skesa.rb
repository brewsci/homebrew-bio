class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/v2.2.1.tar.gz"
  sha256 "9fe712c1c0d69c963efd433c18a66c42136e8a2fe5efacc9791aa3dfb75021e8"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "e1dc095cb40fdb18ed697763b858ec580f9062edbb19a0dbb2fc94d14017a0ee" => :sierra_or_later
    sha256 "c897fa04ed9e5a7b9109e75048dc3a2182f6ef32e5528a8b4f4b6bdb39b25bc1" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    makefile = "Makefile.nongs"

    # https://github.com/ncbi/SKESA/issues/6
    if OS.mac?
      inreplace makefile, "-Wl,-Bstatic", ""
      inreplace makefile, "-Wl,-Bdynamic -lrt", ""
    end

    system "make", "-f", makefile, "BOOST_PATH=#{Formula["boost"].opt_prefix}"
    bin.install "skesa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skesa --version 2>&1")
  end
end
