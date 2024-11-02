class Muscle < Formula
  # cite Edgar_2004: "https://doi.org/10.1186/1471-2105-5-113"
  # cite Edgar_2022: "https://doi.org/10.1038/s41467-022-34630-w"
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/5.1.0.tar.gz"
  sha256 "2bba8b06e3ccabf6465fa26f459763b2029d7e7b9596881063e3aaba60d9e87d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a063eb631b2ca243a3a37a204cb2976711f9e14475e2de3ac09a1d33366f97c6"
    sha256 cellar: :any,                 arm64_sonoma:  "727f51957a68d3ac2235404314a9073405984ce8a55a2ca93d6a584b5ba36b36"
    sha256 cellar: :any,                 ventura:       "6160f9104b19e8883c384e3c01070125ea0ac153fdf3a3274073b41142fd060f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2690e8e9389eb9ed11ec8e15177562670cec326fc71aba75353dd3ce315d4928"
  end

  depends_on "libomp" if OS.mac?

  def install
    cd "src" do
      # Use clang++ instead of g++-11
      inreplace "Makefile", "g++-11", "clang++"
      # libomp is used for OpenMP support
      # -std=c++11 is needed for clang
      inreplace "Makefile", "-fopenmp", "-L#{Formula["libomp"].opt_lib} -lomp -std=c++11" if OS.mac?
      system "make"
      if OS.mac?
        bin.install "Darwin/muscle"
      else
        bin.install "Linux/muscle"
      end
    end
  end

  test do
    assert_match "muscle", shell_output("#{bin}/muscle -version")
  end
end
