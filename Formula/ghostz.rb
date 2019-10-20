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
    sha256 "f0136b33e0b7493ed2c6bcc8f18bbab332252de0c2f3b29e8fffb7b2d6a2a4cb" => :x86_64_linux
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
