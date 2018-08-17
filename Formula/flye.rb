class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.3.5.tar.gz"
  sha256 "d074055b1d8a8a91f0a0b28f98793441e82987ccb569a03d27db7d729a9fadcb"
  head "https://github.com/fenderglass/Flye.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ce7af6e5acbc3be4a2205923bf4ce4c8458bfc09e8b18482d8b37c577bb683a9" => :sierra_or_later
    sha256 "c30715c886bc5e2640ca4c3411423633f2b446da2ca0ab0c37632434e2751303" => :x86_64_linux
  end

  needs :cxx11

  depends_on "python@2"

  def install
    system "python2", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
