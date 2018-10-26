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
    sha256 "fa97844a5fff2cd81d32d4291da4f4c66784dbfd0c242edacaec895b2bb3283b" => :sierra
    sha256 "4842176ab44c893cf4ab86e631a8a62a0dec5b596c11c45a365afb7f0bd4f97d" => :x86_64_linux
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
