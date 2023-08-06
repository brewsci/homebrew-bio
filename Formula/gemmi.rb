class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d225548ddf4289d7adb9a0cce725cf4853474b9903399080f4770c77d4c18929"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "82e51bfe5546627f6c4dc146433f3c2205b300e3b87ef9ae0ef991064b7c71b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "da60be6893256526f4520810199d93a408f2477ee0673073fd70532f664d00a8"
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
