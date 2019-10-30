class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/v2.3.0.tar.gz"
  sha256 "13832e41b69a94d9f64dee7685b4d05f2e94f807ad819afa8d4cd78cee54879d"
  revision 2

  bottle do
    cellar :any
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "a2bd9acebd6330fd0440ad68e505932f3c032c0c746054712bdcafdc6ea437d5" => :mojave
    sha256 "90e08e2a0fbf08060b2ffbbd3e3951840af8fd03e1fea9113758fe67677dc4d1" => :x86_64_linux
  end

  depends_on "boost"

  uses_from_macos "zlib"

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
