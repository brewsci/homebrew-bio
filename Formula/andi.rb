class Andi < Formula
  # cite Hauboid_2015: "https://doi.org/10.1093/bioinformatics/btu815"
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  url "https://github.com/EvolBioInf/andi/archive/refs/tags/v1.15.tar.gz"
  sha256 "2e26ab53c06740b2d71d7905b185f49b53108a918f1640e3610a7f48b485a047"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c18b5df442cab486cfbbfb6d848f8fa6ea63ecf2468b9df5116e2faf4eff4698"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gsl"
  depends_on "libdivsufsort"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/andi --version 2>&1")
  end
end
