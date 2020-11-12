class Kat < Formula
  # cite Mapleson_2016: "https://doi.org/10.1093/bioinformatics/btw663"
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/archive/Release-2.4.1.tar.gz"
  sha256 "068bd63b022588058d2ecae817140ca67bba81a9949c754c6147175d73b32387"
  license "GPL-3.0"
  revision 3
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
  depends_on "scipy"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
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

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec)
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
