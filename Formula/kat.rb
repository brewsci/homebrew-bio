class Kat < Formula
  # cite Mapleson_2016: "https://doi.org/10.1093/bioinformatics/btw663"
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/archive/Release-2.4.2.tar.gz"
  sha256 "d6116cefdb5ecd9ec40898dd92362afe1a76fa560abfe0f2cd29cbe0d95cb877"
  license "GPL-3.0"
  head "https://github.com/TGAC/KAT.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/Release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    rebuild 1
    sha256 catalina: "3de60b22d45daa5e28f03bb4f577c1ff14409f46f3fddb19407737b42e8392df"
    sha256 x86_64_linux: "232a183bdce0f0a9565fc39aacf8cfe4ec019e4c86cf6f64a9177e96ca64bbd2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "boost"
  depends_on "brewsci/bio/matplotlib"
  depends_on "numpy"
  depends_on "scipy"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  def install
    # Disable unsupported compiler flags on macOS
    inreplace [
      "deps/boost/tools/build/src/tools/darwin.py",
      "deps/boost/tools/build/src/tools/darwin.jam",
    ] do |s|
      s.gsub! "-fcoalesce-templates", ""
      s.gsub! "-Wno-long-double", ""
    end

    boost = Formula["boost"]
    inreplace "lib/Makefile.am", "$(top_builddir)/deps/boost/build/lib", boost.opt_lib
    inreplace ["src/Makefile.am", "tests/Makefile.am"] do |s|
      s.gsub! "$(top_builddir)/deps/boost/build/lib", boost.opt_lib
      s.gsub! "$(top_srcdir)/deps/boost/build/include", boost.opt_include
    end

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("tabulate").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "./autogen.sh"
    system "./configure",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--disable-pykat-install",
      "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
  end
end
