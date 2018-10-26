class Rapidnj < Formula
  # cite Simonsen_2008: "https://doi.org/10.1007/978-3-540-87361-7_10"
  desc "Rapid canonical neighbor-joining tree construction"
  homepage "https://birc.au.dk/Software/RapidNJ/"
  url "http://users-birc.au.dk/cstorm/software/rapidnj/rapidnj-src-2.3.2.zip"
  sha256 "80a30a42cb5390920b4dd2132801083ae67146f9821807b40a4ee9160292e070"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fdcf1723d0f0e1f458c00295d4b7e526cb6165750fcbe28cbc4620b987ada938" => :sierra
    sha256 "59d3c1f3d06aa9a366d571621f3760509865fad6e3fdeaf8f5af781ae9c8def4" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "bin/rapidnj"
  end

  test do
    assert_match "Kimura", shell_output("#{bin}/rapidnj -h 2>&1", 1)
  end
end
