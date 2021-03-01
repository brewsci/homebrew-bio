class Mican < Formula
  # cite Minami_2013: "https://doi.org/10.1186/1471-2105-14-24"
  desc "Structure alignment algorithm that can handle Multiple-chain complexes"
  homepage "http://www.tbp.cse.nagoya-u.ac.jp/MICAN"
  url "http://www.tbp.cse.nagoya-u.ac.jp/MICAN/Download/mican_ver/mican_2019.11.27.tar.gz"
  sha256 "35040d7c26b455e793133879fcfdbc1b233368cdf992e26e4a40330f9c0de757"
  license "CC-BY-2.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "6cdaa93ef59208462e6c1053137fdb5bef77b2005253ffc3d8e1035c1181eb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4969b98b7842df6837fcffa4bb1e3f207e4714b9f4a1857c316fdd960941be06"
  end

  def install
    # remove pre-built binaries
    rm ["mican_linux_64", "mican"]
    # remove pre-compiled files
    rm Dir["src/*.o"]

    system "make"
    bin.install "mican"
  end

  test do
    assert_match "usage", shell_output("#{bin}/mican -h 2>&1", 1)
  end
end
