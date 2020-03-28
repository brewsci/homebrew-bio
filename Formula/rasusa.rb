class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.2.0.tar.gz"
  sha256 "c098a92bffcd2970174109d14769c46dab1b7c6bc80836b85dcca6d1cc922936"

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
