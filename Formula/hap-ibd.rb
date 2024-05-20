class HapIbd < Formula
  # cite Zhou_2020: "https://doi.org/10.1016/j.ajhg.2020.02.010"
  desc "Detect identity-by-descent segments in phased genotype data"
  homepage "https://github.com/browning-lab/hap-ibd"
  url "https://github.com/browning-lab/hap-ibd/archive/refs/tags/v1.0.0-15Jun23.92f.tar.gz"
  version "1.0.0"
  sha256 "9668be3580822a6da5c34fee4c04f05fa51b8471c339fc271a6404556ecc458d"
  license "Apache-2.0"
  head "https://github.com/browning-lab/hap-ibd.git", branch: "master"

  depends_on "openjdk"

  def install
    system "#{Formula["openjdk"].bin}/javac", "-cp", "src/", "src/hapibd/HapIbdMain.java"
    system "#{Formula["openjdk"].bin}/jar", "-cfe", "hap-ibd.jar", "hapibd.HapIbdMain", "-C", "src/", "."

    libexec.install "hap-ibd.jar"
    bin.write_jar_script libexec/"hap-ibd.jar", "hap-ibd"
  end

  test do
    assert_predicate bin/"hap-ibd", :executable?
    assert_predicate libexec/"hap-ibd.jar", :exist?
    assert_match(/^Syntax: java -jar hap-ibd.jar\b/, shell_output("#{bin}/hap-ibd"))
  end
end
