class Bamm < Formula
  # cite Rabosky_2014: "https://doi.org/10.1371/journal.pone.0089543"
  desc "Bayesian analysis of macroevolutionary mixture models on phylogenies"
  homepage "http://bamm-project.org"
  url "https://github.com/macroevolution/bamm/archive/v2.5.0.tar.gz"
  sha256 "526eef85ef011780ee21fe65cbc10ecc62efe54044102ae40bdef49c2985b4f4"
  head "https://github.com/macroevolution/bamm.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fd57d0a4cee9311723afa3ce19cd828fce43f529c79a70b74c1ee9bf0857812d" => :sierra
    sha256 "ea25ffe317ad5d39f8c3c1f4d1d565de1f053a41654333873869f912ca0a4fda" => :x86_64_linux
  end

  depends_on "cmake" => :build

  fails_with :gcc => "4.8" do
    cause "Error: Enable multithreading to use std::thread"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install Dir["examples/*"]
  end

  test do
    cp Dir["#{pkgshare}/diversification/whales/*"], "."
    system "#{bin}/bamm", "-c", "divcontrol.txt"
  end
end
