class Kalign < Formula
  # cite Lassmann_2019: "https://doi.org/10.1093/bioinformatics/btz795"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/v3.2.3.tar.gz"
  sha256 "8fed279d9f58d8263c839f449f9dd0f083dacb54c1dffcc2a9bc14bb9916b8ab"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "95037a99f07ac7ba3729252ee0432f593196adcf375fd71ade1ed9c2e3a0e64b" => :mojave
    sha256 "88b0d12ec4a6a70bb819036c8277bb89eff01fedf7991d6652c489ea86935fc0" => :x86_64_linux
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
