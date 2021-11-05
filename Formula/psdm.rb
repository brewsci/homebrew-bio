class Psdm < Formula
  desc "Compute a pairwise SNP distance matrix from one or two alignment(s)"
  homepage "https://github.com/mbhall88/psdm"
  url "https://github.com/mbhall88/psdm/archive/0.1.0.tar.gz"
  sha256 "d3cc162c392f9086050a84c8ec7c32f498b6db924e651861e797fa9f94040946"
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
    assert_match "USAGE", shell_output("#{bin}/psdm --help")
  end
end
