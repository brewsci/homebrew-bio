class Canu < Formula
  # cite Koren_2017: "https://doi.org/10.1101/gr.215087.116"
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.8.tar.gz"
  sha256 "30ecfe574166f54f79606038830f68927cf0efab33bdc3c6e43fd1448fa0b2e4"
  head "https://github.com/marbl/canu.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "89a2adedebda4320abeacaa395f12303a7aef8c2ea643543796d43e163fb2032" => :sierra
    sha256 "c51a332282420561f760e547f5afa11c23b47942494c7324e52a935c4bb7c291" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "gcc" if OS.mac? # for openmp

  def install
    system "make", "-C", "src"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    rm_r arch/"obj"
    prefix.install arch
    bin.install_symlink prefix/arch/"bin/canu"
  end

  test do
    assert_match "usage", shell_output("#{bin}/canu 2>&1", 1)
  end
end
