class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d225548ddf4289d7adb9a0cce725cf4853474b9903399080f4770c77d4c18929"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "d0ae9d973afab1bc37c0079d447f080550603c04a4a23b0f68a2fef4a5ea8577"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "65b9c863e7275021537f3a7d692179caadf6c9bd22f1152fab01cf6cf3c7cdc5"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemmi --version")
    assert_match "Usage", shell_output("#{bin}/gemmi --help")
    assert_match "|||", shell_output("#{bin}/gemmi align --text-align MMCIF CIF -p")
  end
end
