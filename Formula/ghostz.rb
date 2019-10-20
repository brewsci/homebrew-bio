class Ghostz < Formula
  # cite Suzuki_2014: "https://doi.org/10.1093/bioinformatics/btu780"
  desc "High-speed remote homologue sequence search tool"
  homepage "https://www.bi.cs.titech.ac.jp/ghostz/"
  url "https://www.bi.cs.titech.ac.jp/ghostz/releases/ghostz-1.0.2.tar.gz"
  sha256 "3e896563ab49ef620babfb7de7022d678dee2413d34b780d295eff8b984b9902"
  revision 1

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "45e205642232766d1206e06df7a4e52eea960663b0d520d6f943866db554e596" => :mojave
    sha256 "ce5f132a6ed9a711bffae6648b18f701f55d965e611ef7320847aee24061a19e" => :x86_64_linux
  end

  depends_on "gcc" # for openmp

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "ghostz"
    pkgshare.install Dir["test/*.fa"]
  end

  test do
    # Returns 1 not 0 | https://github.com/akiyamalab/ghostz/issues/3
    assert_match version.to_s, shell_output("#{bin}/ghostz -h 2>&1", 1)
  end
end
