class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.1.0.tar.gz"
  sha256 "a6f9425699e67f01c1052f305cd7a6ad903ebe5b06611586028cd5cb22c88cc5"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "95748966050bee51706ef2488601699922e6cdda746ce30a8ac1994c0666e2bd" => :mojave
    sha256 "a8504c1f9fa3ee5f3e65add03688aa7c0be6cd1ee09abaaa132c11d4ac630dad" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
