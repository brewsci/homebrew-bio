class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/v1.2.tar.gz"
  sha256 "c2cbefcf961925c3368476420e28a63741376773f948094ed845a32291bda436"
  revision 2

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5808430a58991c541f7d3948451b047004cddd7f0b7e427d6226991b85fe93f1" => :sierra
    sha256 "69d7edf2c58a0ee90edd73c653090b578056a36ef0d939ad065ea0279eb7886e" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "fasttree"
  depends_on "gcc" if OS.mac? # needs opemmp
  depends_on "harvest-tools"
  depends_on "libmuscle"
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    # remove binaries
    rm Dir["bin/*"]

    # https://github.com/marbl/parsnp/issues/52
    inreplace "src/parsnp.cpp", "1.0.1", version.to_s

    # we still build this, but runtime will link against libmuscle
    # see: https://github.com/brewsci/homebrew-bio/pull/362
    cd "muscle" do
      ENV.deparallelize
      system "./configure", "--prefix=#{Dir.pwd}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"

    # https://github.com/marbl/parsnp/issues/57
    libr = " -lMUSCLE-3.7"
    inreplace "src/Makefile", libr, ""
    inreplace "src/Makefile", "LIBS =", "LIBS =#{libr}"

    system "make"

    bin.install "src/parsnp"
    pkgshare.install "examples"
    doc.install "CITATION", "LICENSE", "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsnp -v 2>&1")
  end
end
