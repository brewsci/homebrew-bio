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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34be01231343d4bd6f5c60e381a080de5a59ebf3846b3ecc03c258439902c218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b9e997178b554d6cb960c08736693dde5e52767e35b322ca668a7738810c6f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80926c6905e4acedb2708b55e7c3baf04a70af81b8959a7bd8c32c74fb74439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbdc062f4c6a4571c4f3ba57220f87b6df310aca5178cd42430f6848b12a637"
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
