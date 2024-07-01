class Usalign < Formula
  # cite Zhang_2022: "https://doi.org/10.1038/s41592-022-01585-1"
  desc "Universal structure alignment of monomeric, complex proteins and nucleic acids"
  homepage "https://github.com/pylelab/USalign"
  url "https://github.com/pylelab/USalign/archive/38fb294ed437fa7216f1c50f5103bab0be43fc10.tar.gz"
  version "20220924"
  sha256 "f895cf020a73fbdda266225d2a15adbb7d55b9709f7e5a600838418871c4b3a7"
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
