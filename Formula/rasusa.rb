class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.6.0.tar.gz"
  sha256 "516c63142abe4843bb3439e55c6f3e25d8abc22e77fe88019e3f086b229ee0a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ab6a549dd47a972ef941f27d46c8f3a2aa5f451d71a685c29a114dafe9b032a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "66ceec6218531d4cddd83bbc5e72b9bd96e146622fcde708ae916129ce20995e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
