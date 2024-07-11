class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # pull from git tag to get submodules
  url "https://github.com/iqtree/iqtree2.git",
    tag:      "v2.3.5",
    revision: "74da454bbd98d6ecb8cb955975a50de59785fbde"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_sonoma: "e3ed429dda7582a3a4d536da661379292d0465885b101e624e6c856241ffc1f3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "gsl"   => :build
  depends_on "libomp" if OS.mac?
  depends_on "llvm" if OS.mac?
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      ENV.append_path "PREFIX_PATH", buildpath/"lsd2"
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree2 -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/iqtree2 --version")
  end
end
