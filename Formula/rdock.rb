class Rdock < Formula
  desc "Fast, versatile open source docking program for proteins and nucleic acids"
  homepage "https://rdock.github.io/"
  url "https://github.com/CBDD/rdock/archive/refs/tags/v24.04.204-legacy.tar.gz"
  sha256 "cf5bf35d60254ae74c45f0c5ed3050513bbc8ae8df9c665157eb26f6b5a33d16"
  license "LGPL-3"
  head "https://github.com/CBDD/rdock.git", branch: "master"

  depends_on "gcc" => :build
  depends_on "popt"

  def install
    system "export", "CXX=$(which g++-14)"
    system "make"
    system "PREFIX=#{prefix}", "make", "install"
  end

  test do
    system "make", "test"
  end
end
