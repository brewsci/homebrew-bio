class Nthits < Formula
  desc "Identifying repeats in high-throughput sequencing data"
  homepage "https://github.com/bcgsc/ntHits"
  url "https://github.com/bcgsc/ntHits/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "7425a51a2ff840806c5e1e22db7e7f4f49dbba23b78fd66e05a098f3bb625455"
  license "MIT"
  head "https://github.com/bcgsc/ntHits.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "4d51d461f5bb9f4b18f43b5dae781f4f47906680968ea5249d0877ba453653bd"
    sha256 cellar: :any, x86_64_linux: "7c19716fbc5c4fe7709c4cbe14b2bc5f1cb7ec1f871dc956db2f380ca9d2cb74"
  end

  depends_on "argparse" => :build
  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "brewsci/bio/btllib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Use Homebrew's argparse
    inreplace "meson.build", "vendor/argparse/include", Formula["argparse"].opt_include
    system "meson", "setup", "build", "--prefix", prefix
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/nthits -h 2>&1", 1)
  end
end
