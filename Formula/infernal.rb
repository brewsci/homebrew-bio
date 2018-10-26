class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/software/infernal/infernal-1.1.2.tar.gz"
  sha256 "ac8c24f484205cfb7124c38d6dc638a28f2b9035b9433efec5dc753c7e84226b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4297291ab9f3a66e671289ecfcd6a282bee0bfcb5d3a35ee1e37c07901d77e93" => :sierra
    sha256 "2efd7a6c009ef225d83bf4cf8fdb5f4246e7ce5790d62664d6c74b8a7a901dad" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "tutorial", "matrices"
    doc.install Dir["documentation/*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/cmsearch #{pkgshare}/tutorial/minifam.cm #{pkgshare}/tutorial/mrum-tRNAs10.fa")
  end
end
