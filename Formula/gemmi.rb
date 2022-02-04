class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "839fe4ad10bc0d9586992be243e0179f7d8d8ce794540bacece221ddf9a6710e"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "3676d5b56a21b80d744f875a8dc7fca1da342a4f617d447aa481891890960a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3866f4a81a539f0a09b044ecea211c8951a83444906d3c2ce303266beff6ac62"
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
