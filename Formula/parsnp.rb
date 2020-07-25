class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/v1.5.2.tar.gz"
  sha256 "780ddb5fd8c626bf77d31af8e620436ca942801de942c682d1f246bbbdcf2c3d"
  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b0e844a937884f368e4b1294e0d356155dd3371bdfe37c778826c0c59b310246" => :sierra
    sha256 "0717e9aa5c6fdff91bb340b415694849813465beae6103fa949c64a774d9a453" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/harvest-tools"
  depends_on "brewsci/bio/libmuscle"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    libmuscle = Formula["brewsci/bio/libmuscle"]

    # remove binaries
    rm Dir["bin/*"]

    # https://github.com/marbl/parsnp/issues/52
    inreplace "src/parsnp.cpp", "1.0.1", version.to_s

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--with-libmuscle=#{libmuscle.opt_prefix}"

    # https://github.com/marbl/parsnp/issues/57
    libr = " -lMUSCLE-#{libmuscle.version}"
    inreplace "src/Makefile", libr, ""
    inreplace "src/Makefile", "LIBS =", "LIBS =#{libr}"

    system "make"

    bin.install "src/parsnp_core"
    bin.install_symlink "parsnp_core" => "parsnp"
    pkgshare.install "examples"
    doc.install "CITATION", "LICENSE", "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parsnp -v 2>&1")
  end
end
