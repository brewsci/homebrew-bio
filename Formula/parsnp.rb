class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/v1.5.2.tar.gz"
  sha256 "780ddb5fd8c626bf77d31af8e620436ca942801de942c682d1f246bbbdcf2c3d"
  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "a314260f40f1935bddabd3c0918615a966a928d9d4943946553df64374342312" => :catalina
    sha256 "c88a39e77c87877394c668db346bfedf2559e4f13f3b54b590db5b999375976d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/harvest-tools"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # remove binaries
    rm Dir["bin/*"]

    # https://github.com/marbl/parsnp/issues/52
    inreplace "src/parsnp.cpp", "1.0.1", version.to_s

    cd "muscle" do
      ENV.deparallelize
      system "./autogen.sh"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
      (doc/"muscle").install "AUTHORS", "ChangeLog"
    end

    inreplace "configure.ac",
              "-I$with_libmuscle",
              "-I$with_libmuscle/include/libMUSCLE-3.7"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--with-libmuscle=#{prefix}"

    # https://github.com/marbl/parsnp/issues/57
    libr = " -lMUSCLE-3.7"
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
