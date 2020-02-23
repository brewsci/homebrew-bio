class Canu < Formula
  # cite Koren_2017: "https://doi.org/10.1101/gr.215087.116"
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.9.tar.gz"
  sha256 "6b086ab6086c050752166500378bc4b3b3543d4c617863e894d296171cee3385"
  head "https://github.com/marbl/canu.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "6042a89505e9c8e553289361dfb2f7d99d3168d4234e97a35e5c91eb38c0820d" => :mojave
    sha256 "e211e9b9c1c3ba20669050606188b5025042ca9a03e2034f7fe135afc5431fc0" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "gcc" if OS.mac? # needs openmp

  def install
    system "make", "-C", "src"
    arch = Pathname.new(Dir["*/bin"][0]).dirname
    rm_r arch/"obj"
    prefix.install arch
    bin.install_symlink prefix/arch/"bin/canu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/canu --version")
  end
end
