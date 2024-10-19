class Iqtree2 < Formula
  # cite Nguyen_2015: "https://doi.org/10.1093/molbev/msu300"
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # pull from git tag to get submodules
  url "https://github.com/iqtree/iqtree2.git",
    tag:      "v2.3.6",
    revision: "e7b30628a1ed17f999fcb68cab51cd4dbca5a9f9"
  license "GPL-2.0-only"
  head "https://github.com/iqtree/iqtree2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "213fcdd0164d515542a219eb9631902c6933cfb38655765d28c921c708c64126"
    sha256 cellar: :any_skip_relocation, ventura:      "004424493c8b56417866435e94d400e77641b5a14cff1c59ee8e9dfdcfbee1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e6f18ef6a342712b070739281046b35f8d4764ad79d2ec9e84a090ac1bcb5d7f"
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
