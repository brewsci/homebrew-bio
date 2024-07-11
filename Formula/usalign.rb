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
    sha256 cellar: :any_skip_relocation, big_sur:      "dd82bac83964d53ead1dde7e51d94672e3bfca7a2a298e2b58c8d8530b491c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94333674ea10ad77c5465c0079b479e84684c0bc7017dcb045e4d61f318bd1db"
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
