class Vt < Formula
  # Tan_2015: "https://doi.org/10.1093/bioinformatics/btv112"
  desc "Toolset for short variant discovery from NGS data"
  homepage "https://github.com/atks"
  url "https://github.com/atks/vt/archive/refs/tags/0.57721.tar.gz"
  sha256 "8f06d464ec5458539cfa30f81a034f47fe7f801146fe8ca80c14a3816b704e17"
  license "MIT"
  head "https://github.com/atks/vt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "5838f5ad5dcdcc8f27f60444a452a01e8df91147efae0525fc80e142a0ebd22c"
    sha256 cellar: :any,                 ventura:      "7a92a5529ce1b54e317fd496a879509b9b41c3a78bc02b697f40e7ae126e56a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fad5567852e9d0941ea76483536bb4f41c8af974573b94d61baad5c2abec9d31"
  end

  depends_on "htslib"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "make"
    system "test/test.sh"
    bin.install "vt"
    pkgshare.install "test"
  end

  test do
    assert_match "multi_partition", shell_output("#{bin}/vt 2>&1")
  end
end
