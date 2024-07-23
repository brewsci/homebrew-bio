class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "1d23695d0d624fa17e02c43b1d730200e526c17a48615593f75ee8fc35402489"
  head "https://github.com/marbl/parsnp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 catalina:     "a314260f40f1935bddabd3c0918615a966a928d9d4943946553df64374342312"
    sha256 x86_64_linux: "c88a39e77c87877394c668db346bfedf2559e4f13f3b54b590db5b999375976d"
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

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--with-libmuscle=#{include}"

    # https://github.com/marbl/parsnp/issues/57
    libr = " -lMUSCLE-3.7"
    inreplace "src/Makefile", libr, ""
    inreplace "src/Makefile", "LIBS =", "LIBS =#{libr}"
    inreplace "src/Makefile", "LDFLAGS = ", "LDFLAGS = -L#{lib}"

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
