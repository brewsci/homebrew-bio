class Nthits < Formula
  desc "Identifying repeats in high-throughput sequencing data"
  homepage "https://github.com/bcgsc/ntHits"
  url "https://github.com/bcgsc/ntHits/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "7425a51a2ff840806c5e1e22db7e7f4f49dbba23b78fd66e05a098f3bb625455"
  license "MIT"
  head "https://github.com/bcgsc/ntHits.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "a569755664f210d24267dfad3418ea987cd8b43a2696813d4d1759c6d969caaf"
    sha256 cellar: :any,                 ventura:      "88fa7d9c2e42ba92ff2ca0680689eee3fc330cdfc98da111212368a63bd54a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ebffadd83b8e355f1de0025765ecd25bac2e50bddce781467a3ec8fc667b721"
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
