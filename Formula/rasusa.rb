class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.4.1.tar.gz"
  sha256 "63aec59cc31081e728179163350271a09dba4cc4f563aeb8057efef763dfc674"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "9aedd186bd85d4a5945a988409e0ea27c86dc9b0b618659dc92c8ac473d1f5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abd0adf78a670077d19c94531f510d079fac45ba23fb0c34c0297bc4558a90ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
