class Rdock < Formula
  desc "Fast, versatile open source docking program for proteins and nucleic acids"
  homepage "https://rdock.github.io/"
  url "https://github.com/CBDD/rdock/archive/refs/tags/v24.04.204-legacy.tar.gz"
  sha256 "cf5bf35d60254ae74c45f0c5ed3050513bbc8ae8df9c665157eb26f6b5a33d16"
  license "LGPL-3.0-only"
  head "https://github.com/CBDD/rdock.git", branch: "main"

  depends_on "gcc" => :build
  depends_on "perl"
  depends_on "popt"
  depends_on "python"

  def install
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"
    ENV["CXXFLAGS"] = "-std=c++14 -Wno-deprecated-declarations"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["gcc"].opt_lib}/gcc/14" if OS.mac?

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cd buildpath do
      system "make", "test"
    end
  end
end
