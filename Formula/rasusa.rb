class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.2.0.tar.gz"
  sha256 "c098a92bffcd2970174109d14769c46dab1b7c6bc80836b85dcca6d1cc922936"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "df58a454ce4a466088dd492d7e0044a7080892261a7a1ccb16bf8133b4007b08" => :catalina
    sha256 "13b3cfd066b55b0560ea715711b80dcfdbb9d75446019d4793dea54a31e84ac4" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
