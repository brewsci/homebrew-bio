class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "1d23695d0d624fa17e02c43b1d730200e526c17a48615593f75ee8fc35402489"
  head "https://github.com/marbl/parsnp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "d00efe0566c3c017d36630032599b252e5a19a78c01279fd8bbfba7abdf2045f"
    sha256 cellar: :any,                 ventura:      "6357c9eac4ac96eebaf8825cbb06eafcd26a30c0a0838b4e673889544683b9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36a5646f5c4c611c5e1b384541b06f490bb424f34a8e98439ab1e294a708b922"
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
