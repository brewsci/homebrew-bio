class Psdm < Formula
  desc "Compute a pairwise SNP distance matrix from one or two alignment(s)"
  homepage "https://github.com/mbhall88/psdm"
  url "https://github.com/mbhall88/psdm/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0414b2fde2e6c43a7d9bfd7a53da67f8e084cc4ec350ad7c498cc1937b9a15cc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c6a4f3d267396ff265c46f585bfa315ebbe12872771e537a3710b77ba394ad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3b97e3476f93598ef4ad759470bf121bc32578a6dcb43ab30e80794ed36bc5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea194314af4d8b946e3f8ea7cd45079afe2bb1d209cbff644aff5a4f2cd6ed56"
    sha256 cellar: :any,                 x86_64_linux:  "c6ecdb8a862cf54fa7f9765c9d04a9054c66f5f77140766ab8b81a4054de4cc4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/psdm --help")
  end
end
