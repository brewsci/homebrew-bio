class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.7.1.tar.gz"
  sha256 "575e71f7736e127ba8360e08cb1fbfd297e7519c41381ef6057b48d142cacf74"
  license "GPL-2.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ffe5a0cd4fc81d4120ed1ac0769e863a54c361adfbd191b5accfc3fd676469c7" => :catalina
    sha256 "4433c4c8550fdb5a329532888461cbdd733256fa5232cacc1882a395f34d31c3" => :x86_64_linux
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
    assert_match "Dating results",
     shell_output("#{bin}/lsd2 -i #{testpath}/h1n1_phyml.tree -d #{testpath}/h1n1.date -e 3 -u 0.1 -l 0 2>&1")
  end
end
