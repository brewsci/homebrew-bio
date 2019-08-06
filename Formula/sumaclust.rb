class Sumaclust < Formula
  desc "Fast and exact sequence clustering for DNA metabarcoding"
  homepage "https://git.metabarcoding.org/obitools/sumaclust/wikis/home"
  url "https://git.metabarcoding.org/obitools/sumaclust/uploads/f0ca7538f8a342f4479dcdf8df898e0c/sumaclust_v1.0.34.tar.gz"
  sha256 "b879f770ecc604c2dab5e466c4c69cb37e74c75abf4c6400dcee085af909473d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "928976d827f0c435404389a8fbe9404ef3540662036fd4537702a2708484fced" => :sierra
    sha256 "6ab6841a4dfbb7967f8a3e432f02bd7081d26cbdd894f7873eefbb94cacd027c" => :x86_64_linux
  end

  def install
    system "make", "-C", "sumalibs", "install"
    system "make", "CC=clang"
    system "make", "install"
    bin.install "sumaclust"
    doc.install "sumaclust_user_manual.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sumaclust -h 2>&1")
  end
end
