class Andi < Formula
  # cite Hauboid_2015: "https://doi.org/10.1093/bioinformatics/btu815"
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  url "https://github.com/EvolBioInf/andi/archive/v0.12.tar.gz"
  sha256 "3fdc1deac881e0db44a709702d1b43eea898e4c1f20ff38007adc60728c98557"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "7984d474d09cd3020985a5b95ca429f42b8b638e7ab888ff8cd74659abd7701d" => :sierra
    sha256 "78fff51d8900bc200d3500216d3309bc821c246a5308fd145b865a40dde557eb" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gsl"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--without-libdivsufsort"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/andi --version 2>&1")
  end
end
