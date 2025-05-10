class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/refs/tags/v.2.4.1.tar.gz"
  sha256 "3d0921c96edb8f30498dc8a27878a76d785516043fbede4a72eefd84b5955458"
  license "GPL-2.0-only"
  head "https://github.com/tothuhien/lsd2.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "525e3fc3059d4cd8284660f8b46875f3d1378afab5d6bc97213d00363c5a6144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80926c6905e4acedb2708b55e7c3baf04a70af81b8959a7bd8c32c74fb74439"
    sha256 cellar: :any_skip_relocation, ventura:       "bca2cd6093728031fc193be83881854271e95d438a850fef1c502edfc696aed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0807b7ecd12673e5980bda8038ba0faae29eb671ef7de1bee8943a40869b38a4"
  end

  def install
    system "make", "-C", "src"
    bin.install "src/lsd2"
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsd2 -V 2>&1")
    cp "#{pkgshare}/examples/rooted_tree/h1n1_phyml.tree", testpath
    cp "#{pkgshare}/examples/rooted_tree/h1n1.date", testpath
    cmd = "#{bin}/lsd2 -i #{testpath}/h1n1_phyml.tree -d #{testpath}/h1n1.date -r l -f 100 -s 1000 -q 0.4"
    assert_match "Dating results",
    shell_output("#{cmd} 2>&1")
  end
end
