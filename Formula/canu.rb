class Canu < Formula
  # cite Koren_2017: "https://doi.org/10.1101/gr.215087.116"
  desc "Single molecule sequence assembler"
  homepage "https://canu.readthedocs.org/en/latest/"
  url "https://github.com/marbl/canu/archive/v1.6.tar.gz"
  sha256 "470e0ac761d69d1fecab85da810a6474b1e2387d7124290a0e4124d660766498"
  head "https://github.com/marbl/canu.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "acb7b2ac25a219e522bfb467b35299ca87bd944724f602a0bf84c7d45790c159" => :sierra_or_later
    sha256 "1391c084e04168491ba6d9b6c1f6340b79b56e269d0e7ba75df60f15a800a550" => :x86_64_linux
  end

  # Fix fatal error: 'omp.h' file not found
  depends_on "gcc" unless OS.mac? # for openmp

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
