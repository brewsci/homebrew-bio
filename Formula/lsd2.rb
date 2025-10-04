class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/refs/tags/v.2.4.1.tar.gz"
  sha256 "3d0921c96edb8f30498dc8a27878a76d785516043fbede4a72eefd84b5955458"
  license "GPL-2.0-only"
  head "https://github.com/tothuhien/lsd2.git", branch: "master"

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
