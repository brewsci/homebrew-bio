class Skesa < Formula
  # cite Souvorov_2018: "https://doi.org/10.1186/s13059-018-1540-z"
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://github.com/ncbi/SKESA"
  url "https://github.com/ncbi/SKESA/archive/v2.3.0.tar.gz"
  sha256 "13832e41b69a94d9f64dee7685b4d05f2e94f807ad819afa8d4cd78cee54879d"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "8efd0cbd2c73b5bc891a9a22c8e8cb1a338febe8c2bc448f3d4320998abb895e" => :sierra
    sha256 "1f1b6ce810c86616be30dc6267d65416fcfc1d1487083f9e6063242e068ea077" => :x86_64_linux
  end

  depends_on "boost"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "ngs" do
    url "https://github.com/ncbi/ngs/archive/2.9.6.tar.gz"
    sha256 "4be42f4d62b2376dc2fc4cd992822525bd99f8e1193008c2dab387a2f291405b"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.9.6.tar.gz"
    sha256 "3b13ae1362b01f8300a6e8b75742857bd8b0c9ee62561f9fdd4a46be384451d6"
  end

  def install
    ENV.cxx11

    # https://github.com/ncbi/SKESA/issues/6
    if OS.mac?
      inreplace "Makefile", "-Wl,-Bstatic", ""
      inreplace "Makefile", "-Wl,-Bdynamic -lrt", ""
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "10.9" if MacOS.version < :high_sierra
    end

    # Replicate build steps by unpacking ngs and ncbi-vdb ourselves.
    resource("ngs").stage do
      cd "ngs-sdk" do
        system "./configure", "--prefix=#{libexec}/ngs_out"
        system "make", "install"
      end
    end

    resource("ncbi-vdb").stage do
      ENV.deparallelize
      system "./configure", "--prefix=#{libexec}/vdb_out", "--with-ngs-sdk-prefix=#{libexec}/ngs_out"
      inreplace "Makefile", "-mmacosx-version-min=version=10.6", "-mmacosx-version-min=version=10.9" if MacOS.version < :high_sierra
      system "make", "install"
    end

    touch libexec/"ngs.done" # Build system needs this flag file

    system "make", "BOOST_PATH=#{Formula["boost"].opt_prefix}", "NGS_DIR=#{libexec}"
    bin.install "skesa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skesa --version 2>&1")
  end
end
