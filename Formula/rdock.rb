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

  patch do
    url "https://raw.githubusercontent.com/eunos-1128/rDock/refs/heads/patch/homebrew/NMObjective.h.patch"
    sha256 "5633b36c6a5e9f74a3855afd3e05ac9e3c7a588471e7f16ac508736ab093b6f7"
  end

  patch do
    url "https://raw.githubusercontent.com/eunos-1128/rDock/refs/heads/patch/homebrew/perl_lib.patch"
    sha256 "5f9f80fdde788858aa8b8295ae75dddc2cb34ecbc0cdc7e5c7d38fb719ba1926"
  end

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
