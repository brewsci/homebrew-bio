class Rasusa < Formula
  # cite Hall_2022: "https://doi.org/10.21105/joss.03941"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/0.7.0.tar.gz"
  sha256 "5884bddeb1c40791c02677afb080c4e938ef422924f1a5d5a0fa5c4a17f4d9fe"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 big_sur:      "c62b56a9dcede7fdd4cf050328d4e38f0192e9562b5bd8f47723b728f35d8990"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc77b0c804e917390aef39b306d13293c5c3f79a0949a7be35d418d8ab5a16c0"
  end

  depends_on "rust" => :build
  depends_on "xz"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
