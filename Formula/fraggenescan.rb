class Fraggenescan < Formula
  # cite Rho_2010: "https://doi.org/10.1093/nar/gkq747"
  desc "Predicting genes in short and error-prone reads"
  homepage "https://github.com/COL-IU/FragGeneScan"
  url "https://downloads.sourceforge.net/project/fraggenescan/FragGeneScan1.31.tar.gz"
  sha256 "cd3212d0f148218eb3b17d24fcd1fc897fb9fee9b2c902682edde29f895f426c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "02d0741b14113b9df714ce874579c59c3bfa4a1d10683010b008835ad051a4ff" => :sierra_or_later
    sha256 "816966b16547812cf8be5c04670356394e3acd98718ba90b797cd687026e4b35" => :x86_64_linux
  end

  depends_on "perl" unless OS.mac?

  def install
    system "make", "clean"
    prefix.install Dir["*"]
    bin.install_symlink Dir["#{prefix}/run_FragGeneScan.pl"]
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/run_FragGeneScan.pl 2>&1")
  end
end
