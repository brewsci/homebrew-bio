class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/v2.3.0.tar.gz"
  sha256 "13832e41b69a94d9f64dee7685b4d05f2e94f807ad819afa8d4cd78cee54879d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "8efd0cbd2c73b5bc891a9a22c8e8cb1a338febe8c2bc448f3d4320998abb895e" => :sierra
    sha256 "1f1b6ce810c86616be30dc6267d65416fcfc1d1487083f9e6063242e068ea077" => :x86_64_linux
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
