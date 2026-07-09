class Andi < Formula
  # cite Hauboid_2015: "https://doi.org/10.1093/bioinformatics/btu815"
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  url "https://github.com/EvolBioInf/andi/archive/refs/tags/v1.15.tar.gz"
  sha256 "2e26ab53c06740b2d71d7905b185f49b53108a918f1640e3610a7f48b485a047"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "5047a1c68930f5d9c54643667050541c5ef91b6d30f8be619045daa5ab9c2866"
    sha256 cellar: :any, arm64_sequoia: "09707c7ae3a4e44582517dc0ff9ff0124122ca39b7f4fcb704939ee67ea82628"
    sha256 cellar: :any, arm64_sonoma:  "85552976f9462f504223f56da1159016aadcff332348b146b9842358b33ea9ba"
    sha256 cellar: :any, x86_64_linux:  "5ed8d5c6d6e23ba5c38aaf30e6fabee7a1b5e9b705a6ec5c5e1352c281dadb1e"
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
