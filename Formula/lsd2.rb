class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.7.1.tar.gz"
  sha256 "575e71f7736e127ba8360e08cb1fbfd297e7519c41381ef6057b48d142cacf74"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "feba97e5dc1630bf6574efcdce71c4d589437f85964df534fb646207032dad47" => :catalina
    sha256 "f077847fbfbe4f247a92ed9dc6ef5e85147488752a5466a2668cc159a5471204" => :x86_64_linux
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
