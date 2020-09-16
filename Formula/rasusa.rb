class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  url "https://github.com/mbhall88/rasusa/archive/0.3.0.tar.gz"
  sha256 "605c47beabc58101ae56451d6cd30dc71c3fd4b3c46af051781bef875879f24f"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9aedd186bd85d4a5945a988409e0ea27c86dc9b0b618659dc92c8ac473d1f5be" => :catalina
    sha256 "abd0adf78a670077d19c94531f510d079fac45ba23fb0c34c0297bc4558a90ad" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rasusa --help")
  end
end
