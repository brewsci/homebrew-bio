class Kat < Formula
  # cite Mapleson_2016: "https://doi.org/10.1093/bioinformatics/btw663"
  desc "K-mer Analysis Toolkit (KAT) analyses k-mer spectra"
  homepage "https://github.com/TGAC/KAT"
  url "https://github.com/TGAC/KAT/archive/Release-2.4.1.tar.gz"
  sha256 "068bd63b022588058d2ecae817140ca67bba81a9949c754c6147175d73b32387"
  revision 2
  head "https://github.com/TGAC/KAT.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "716d18717e180adaeca2eadea2a9de1a6e799387e828c69e0beeb9ca348ba629" => :sierra
    sha256 "e3dd3d91df335579c48e6d08decd591c302b8a42cabb7d6c5f01c6c4dc1e8c0d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "matplotlib"
  depends_on "scipy"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  needs :cxx11

  def install
    # Reduce memory usage for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

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
