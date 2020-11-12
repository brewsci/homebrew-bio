class Aragorn < Formula
  # cite Laslett_2004: "https://doi.org/10.1093/nar/gkh152"
  desc "Detect tRNA and tmRNA genes in contigs"
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.38.tgz"
  sha256 "4b84e3397755fb22cc931c0e7b9d50eaba2a680df854d7a35db46a13cecb2126"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f896ddcae611fbc70e626039eefb08613ccc734ad5bd2c17cd8f514f1531021a" => :sierra
    sha256 "7670f2b0c66f5567844300f3c7b909cc679948e2fea74657631b025b24ce0520" => :x86_64_linux
  end

  def install
    mv "aragorn#{version}.c", "aragorn.c"
    system "make", "aragorn"
    bin.install "aragorn"
    man1.install "aragorn.1"
  end

  test do
    (testpath/"test.fa").write <<~EOS
      >sequence
      GGGGCTATAGCTCAGTTGGGAGAGCGCTGCAATCGCACTG
      CAGAGGTCGTCAGTTCGAACCTGACTAGCTCCACCA
    EOS
    assert_match "tRNA-Ala", shell_output("#{bin}/aragorn -w #{testpath}/test.fa")
  end
end
