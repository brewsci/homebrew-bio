class Kalign < Formula
  # cite Lassmann_2019: "https://doi.org/10.1093/bioinformatics/btz795"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.2.3.tar.gz"
  sha256 "8fed279d9f58d8263c839f449f9dd0f083dacb54c1dffcc2a9bc14bb9916b8ab"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2f68f59172ef17a85e0d9a568b7e425cab1fb2a1b79d164ab7b13dc380fdaac5" => :catalina
    sha256 "f37d14ced6a5aa58b2375f6e14827dd111ab0fffdb28786fa741663aaf085e33" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalign -V 2>&1")
  end
end
