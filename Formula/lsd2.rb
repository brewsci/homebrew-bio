class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.3.tar.gz"
  sha256 "c31ea092cd38c784c3d00f03959be42462a002de0d6a024effbd7b5ff829951b"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "bc3fbc38d1126f0f502d49e93a7c639893cef9b996c468f623a9351ed7a4d046" => :sierra
    sha256 "9a79037099326fb802b2f42c86deaea699bc0bd90cfe1f6ff4b45d941a722dc1" => :x86_64_linux
  end

  def install
    # https://github.com/tothuhien/lsd2/issues/5
    inreplace "src/makefile", "FLAGS=", "FLAGS=-Ofast -Wall "
    system "make", "-C", "src"
    bin.install "src/lsd2"
    pkgshare.install "examples"
  end

  test do
    assert_match "confidence", shell_output("#{bin}/lsd2 -h 2>&1")
  end
end
