class Parsnp < Formula
  # cite Treangen_2014: "https://doi.org/10.1186/s13059-014-0524-x"
  desc "Microbial core genome alignment and SNP detection"
  homepage "https://github.com/marbl/parsnp"
  url "https://github.com/marbl/parsnp/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "1d23695d0d624fa17e02c43b1d730200e526c17a48615593f75ee8fc35402489"
  head "https://github.com/marbl/parsnp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "e84a287dae34cf6c71be80fcd6d082d138ab0700b228720d875a0de9287afbd5"
    sha256 cellar: :any, arm64_sequoia: "5fb18716a21235733a0fe49c9322cc6a55e484811a109fd7b76e1e3fc1e5bd9a"
    sha256 cellar: :any, arm64_sonoma:  "aa410a1f8e71b4752f60832886480fc18f1d9493536f607f4e32a620749bc119"
    sha256 cellar: :any, x86_64_linux:  "ce839d1e25d412af80afa662bf8be98ac951d125eb85af58d67d28a8a61c1c38"
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
