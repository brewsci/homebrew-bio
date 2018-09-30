class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.3.6.tar.gz"
  sha256 "0793cb8963743b3ce84f701e1a63a08b7bbb5fb9342f19b2eefad92ceee546f2"
  head "https://github.com/fenderglass/Flye.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ce7af6e5acbc3be4a2205923bf4ce4c8458bfc09e8b18482d8b37c577bb683a9" => :sierra_or_later
    sha256 "c30715c886bc5e2640ca4c3411423633f2b446da2ca0ab0c37632434e2751303" => :x86_64_linux
  end

  depends_on "python@2"

  needs :cxx11

  def install
    system "python2", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
