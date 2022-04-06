class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c58dde34751a27aca30dabdf925a79dd179093ed1b1952172a116bbd12a350b9"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "0d61b3b9d065e2aa1cc404f0656ecad79db74970b4d1ca937c2842fcf5b1e024"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e12d0fc99ceabf787593b472d94cd5bc791f22818aefe9784e17669e483839f2"
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
