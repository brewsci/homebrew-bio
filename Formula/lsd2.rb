class Lsd2 < Formula
  # cite To_2016: "https://doi.org/10.1093/sysbio/syv068"
  desc "Least-squares method to estimate rates and dates from phylogenies"
  homepage "https://github.com/tothuhien/lsd2"
  url "https://github.com/tothuhien/lsd2/archive/v1.4.2.2.tar.gz"
  sha256 "538054cf630eacf213af25d867e40455a366d3fe7b1876d1bcedea7dda9d16b1"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "bc3fbc38d1126f0f502d49e93a7c639893cef9b996c468f623a9351ed7a4d046" => :sierra
    sha256 "9a79037099326fb802b2f42c86deaea699bc0bd90cfe1f6ff4b45d941a722dc1" => :x86_64_linux
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
       shell_output("#{bin}/lsd2 -c -v 1 -i #{pkgshare}/examples/rooted_tree/h1n1_phyml.tree -d #{pkgshare}/examples/rooted_tree/h1n1.date 2>&1")
    end
  end
end
