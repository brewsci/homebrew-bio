class Ispcr < Formula
  desc "In silico PCR - from primers to products"
  homepage "http://hgwdev.cse.ucsc.edu/~kent/src/"
  url "https://users.soe.ucsc.edu/~kent/src/isPcr33.zip"
  sha256 "7019ec30440d8b91935ce23700bc2330e140b514e59344f8cda4c6b7146e14fc"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "85489c58247d2182937f3449a2a838ad020691f9a796eacd1aa482fb58534236" => :sierra
    sha256 "99c9b17d01cb0618b6ca9bd37e27dfd1c721204da3e9860f19bfb38dfc2ca995" => :x86_64_linux
  end

  def install
    arch = "unix"
    ENV["MACHTYPE"] = arch
    ENV["HOME"] = buildpath.to_s
    inreplace "inc/common.mk", "-Werror", ""
    mkdir_p "#{buildpath}/lib/#{arch}"
    mkdir_p "#{buildpath}/bin/#{arch}"
    system "make"
    bin.install Dir["bin/#{arch}/*Pcr"]
    doc.install "isPcr/README", "isPcr/version.doc", "isPcr/install.txt"
  end

  test do
    assert_match "In-Situ PCR", shell_output("#{bin}/isPcr 2>&1", 255)
  end
end
