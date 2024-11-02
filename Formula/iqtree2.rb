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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043e5cfc7c1cffa7457165123a237ef38305f3960d86f015552f20d5a04d2b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcea6ddabffb2de66f26d5cb1fc31c37c21279db1eb1b0560f67669d3f65e84"
    sha256 cellar: :any_skip_relocation, ventura:       "9255796ac71623c8b774f1ad524b7e549f383a03d239bf3f6d44c20d96e3f294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20021aa07edd77761cbfb6026d2fa2a20e813a919517803c6c450384c6a1986"
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
