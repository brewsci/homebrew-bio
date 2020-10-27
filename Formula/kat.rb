class Kat < Formula
  # cite Mapleson_2016: "https://doi.org/10.1093/bioinformatics/btw663"
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/archive/Release-2.4.2.tar.gz"
  sha256 "d6116cefdb5ecd9ec40898dd92362afe1a76fa560abfe0f2cd29cbe0d95cb877"
  license "GPL-3.0"
  head "https://github.com/TGAC/KAT.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "395fea7e48ae8295cd51387cb11537c67586bbfe7912f27a5b56eb0620980f92" => :catalina
    sha256 "5006a1a39cff6a90bd40c279853eb99e2366e5002614136f6a427c075a813810" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "brewsci/bio/matplotlib"
  depends_on "python@3.9"
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

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.9/site-packages"

    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
      end
    end

    system "./build_boost.sh"
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
