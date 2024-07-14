class Usalign < Formula
  # cite Zhang_2022: "https://doi.org/10.1038/s41592-022-01585-1"
  desc "Universal structure alignment of monomeric, complex proteins and nucleic acids"
  homepage "https://github.com/pylelab/USalign"
  url "https://github.com/pylelab/USalign/archive/8b191c9ab338745611804fcbc088f0403b1d2a8c.tar.gz"
  version "20240706"
  sha256 "8a53946397c15034195c6b18c921b489f2a20595b13dd3066dfa5d4fcc43f5a8"
  license :cannot_represent
  head "https://github.com/pylelab/USalign.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "627ed3a998c2d2205359929a724b9913f22e84f35a6c9d86c85233bb35801956"
    sha256 cellar: :any_skip_relocation, ventura:      "71e08efed94c5cfda83aa7fac49389d49ac45d112afc1066385b386fbfaced8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19ff8e42faed17d5ff615d926c518dc4374f87584f4b3b40caeb7abadaa1c061"
  end

  def install
    # install cpp version
    system ENV.cxx, "-O3", "-ffast-math", "-lm", "-o", "USalign", "USalign.cpp"
    bin.install "USalign"
  end

  test do
    assert_match "usage", shell_output("#{bin}/USalign -h 2>&1")
  end
end
