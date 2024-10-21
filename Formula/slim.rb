class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/refs/tags/v4.3.tar.gz"
  sha256 "b390a6638a915d6f955608610bca6e94fc0f4d62f5ad07376b2aa98756e8c81d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838c0f08b79023d5f35b5f885ce17c4992c539edbe135fdc751127a9a8d2f832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c010b83b5b0a7bdf2ab90fbcdb173e825e445b2331d9488ab67e1ac809cb36c6"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5cfa8b5f9173fee5079a7e898eea782fca60f808291ab1e9faf65802b5f096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435b1ffd6bde366933bad6b89d6ec8d7d11a1fdc80aae6f978de94565bdec571"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/slim", "-testEidos"
    system "#{bin}/slim", "-testSLiM"
  end
end
