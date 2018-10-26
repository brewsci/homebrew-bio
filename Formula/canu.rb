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
    sha256 "59f3483787bad2a576927d253a6bb4f3ebed42b4ff39f7974fb52287340b8e0e" => :sierra
    sha256 "b5601d86b86046f9bde3fb509fd33efcd04f81a2c34da2b2502a51c0529026ae" => :x86_64_linux
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
