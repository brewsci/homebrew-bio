class Canu < Formula
  # cite Koren_2017: "https://doi.org/10.1101/gr.215087.116"
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.7.tar.gz"
  sha256 "c5be54b0ad20729093413e7e722a19637d32e966dc8ecd2b579ba3e4958d378a"
  revision 1
  head "https://github.com/marbl/canu.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "25e519d43ded5a33afdd43fa3f757d65d6af3774257f13e6c78cf835650f4156" => :sierra_or_later
    sha256 "07f832430879c3cd2baa67b7db097da135cd82ecfe218a9afb1bc7f861b46c0f" => :x86_64_linux
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
