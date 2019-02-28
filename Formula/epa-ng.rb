class EpaNg < Formula
  # cite Barbera_2018: "https://doi.org/10.1093/sysbio/syy054"
  desc "Massively parallel phylogenetic placement of genetic sequences"
  homepage "https://github.com/Pbdas/epa-ng"
  url "https://github.com/Pbdas/epa-ng/archive/v0.3.5.tar.gz"
  sha256 "0aa2aa9ffad0d713c42ea43330798a4d701ece883ced617da07218b7c697df41"
  head "https://github.com/Pbdas/epa-ng.git"

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install "bin/epa-ng"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/epa-ng --help")
  end
end
