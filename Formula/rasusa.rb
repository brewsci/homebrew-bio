class Rasusa < Formula
  # cite Hall_2022: "https://doi.org/10.21105/joss.03941"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.7.0.tar.gz"
  sha256 "5884bddeb1c40791c02677afb080c4e938ef422924f1a5d5a0fa5c4a17f4d9fe"
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
