class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/v2.2.1.tar.gz"
  sha256 "9fe712c1c0d69c963efd433c18a66c42136e8a2fe5efacc9791aa3dfb75021e8"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "b6ed1df3135f09bb9cd647d8266a62d0bef04748e5b87586f86768b4851b3f96" => :sierra_or_later
    sha256 "44c29dea16559d273a9b0e1131b9ecea9555e9608afd9c8e08bbf00406a388f4" => :x86_64_linux
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
