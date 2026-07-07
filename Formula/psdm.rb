class Psdm < Formula
  desc "Compute a pairwise SNP distance matrix from one or two alignment(s)"
  homepage "https://github.com/mbhall88/psdm"
  url "https://github.com/mbhall88/psdm/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0414b2fde2e6c43a7d9bfd7a53da67f8e084cc4ec350ad7c498cc1937b9a15cc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "5078e02e21545870e94086213fd34b674d702b247d67985357bc54773010dd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4b4b2cc9cad3bf693a005cd1ccc98a8ed886c6875f1f7563504c6a3ea964147f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/psdm --help")
  end
end
