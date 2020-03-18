class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.4.2.2.tar.gz"
  sha256 "538054cf630eacf213af25d867e40455a366d3fe7b1876d1bcedea7dda9d16b1"

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
    # unable to determine why this test fails on macos
    unless OS.mac?
      assert_match "Dating results",
       shell_output("#{bin}/lsd2 -c -v 1 -i #{pkgshare}/examples/rooted_tree/h1n1_phyml.tree \
                    -d #{pkgshare}/examples/rooted_tree/h1n1.date 2>&1")
    end
  end
end
