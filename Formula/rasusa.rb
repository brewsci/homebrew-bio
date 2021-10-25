class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.6.0.tar.gz"
  sha256 "516c63142abe4843bb3439e55c6f3e25d8abc22e77fe88019e3f086b229ee0a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ceb547824d4bf648073cd1936cc808887b232e814e6241561165379eb2159462"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b8fcd7eb559031f0dbbb837b757044fec7ac46f3b9e464ad360aa157dd9f83b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
