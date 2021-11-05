class Psdm < Formula
  desc "Compute a pairwise SNP distance matrix from one or two alignment(s)"
  homepage "https://github.com/mbhall88/psdm"
  url "https://github.com/mbhall88/psdm/archive/0.1.0.tar.gz"
  sha256 "d3cc162c392f9086050a84c8ec7c32f498b6db924e651861e797fa9f94040946"
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
