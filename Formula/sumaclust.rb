class Sumaclust < Formula
  desc "Fast and exact sequence clustering for DNA metabarcoding"
  homepage "https://git.metabarcoding.org/obitools/sumaclust/wikis/home"
  url "https://git.metabarcoding.org/obitools/sumaclust/uploads/c6577f046014f6720da072a4d6217a65/sumaclust_v1.0.34.tar.gz"
  sha256 "e295f1079ef8fe5b746b5769488208079c29b9c638cfef282bfc3d2bdcc2ecc5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "928976d827f0c435404389a8fbe9404ef3540662036fd4537702a2708484fced" => :sierra
    sha256 "6ab6841a4dfbb7967f8a3e432f02bd7081d26cbdd894f7873eefbb94cacd027c" => :x86_64_linux
  end

  def install
    if OS.mac?
      system "make", "CC=clang"
    else
      system "make"
    end
    bin.install "sumaclust"
    doc.install "sumaclust_user_manual.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sumaclust -h 2>&1")
  end
end
