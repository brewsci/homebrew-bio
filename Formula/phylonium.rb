class Phylonium < Formula
  # cite Kl_tzl_2019: "https://doi.org/10.1093/bioinformatics/btz903"
  desc "Fast and Accurate Estimation of Evolutionary Distances"
  homepage "https://github.com/EvolBioInf/phylonium"
  url "https://github.com/EvolBioInf/phylonium/archive/refs/tags/v1.5.tar.gz"
  sha256 "5cfab29b8753f5b38e6363fa1ba387578863e3bbb8fd1a9722abdc32d1c90686"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "b13c1533fd0f9f74663223f7e690e4bf0a5ebf749d0fe2a3ee11c4c01dc0741d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a993f505a59996367da6c91a046a2af82de55feb4302ca3543e7e368c80712f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gcc"
  depends_on "libdivsufsort"

  fails_with gcc: "4.9" # requires C++14(?)
  fails_with gcc: "5" # requires C++14(?)

  resource("simf") do
    url "https://raw.githubusercontent.com/EvolBioInf/phylonium/3baee10acbb82fc33f2b052d6adf10d33e8b64cf/test/simf.cxx"
    sha256 "31642a3c0f9fbfd7fe6de3a4819599b87b426fd96a1bebb37c9d4ee9d48dfb1b"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylonium --version 2>&1")

    resource("simf").stage do
      system ENV.cxx.to_s, "-std=c++14", "-Wall", "-Wextra", "simf.cxx", "-o", "simf"
      system "./simf", "-s", "1729", "-l", "100000", "-p", "simple"
      system "#{bin}/phylonium simple0.fasta simple1.fasta > /dev/null"
      rm "simple0.fasta"
      rm "simple1.fasta"
    end
  end
end
