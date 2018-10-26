class Trimal < Formula
  # cite Capella_2009: "https://doi.org/10.1093/bioinformatics/btp348"
  desc "Automated alignment trimming in phylogenetic analyses"
  homepage "http://trimal.cgenomics.org/"
  url "https://github.com/scapella/trimal/archive/v1.4.1.tar.gz"
  sha256 "cb8110ca24433f85c33797b930fa10fe833fa677825103d6e7f81dd7551b9b4e"
  head "https://github.com/scapella/trimal"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e1796872ec4389f87131dea98c4596aa387090d4eb476f1e1472e3763bbc09ed" => :sierra
    sha256 "e10f7b254386950ff2944caf0b1eb924d0854618485c7cb534ba5f058dc56b17" => :x86_64_linux
  end

  def install
    system "make", "-C", "source", "CC=c++"
    bin.install "source/readal", "source/trimal", "source/statal"
    pkgshare.install "dataset"
  end

  test do
    %w[trimal readal statal].each do |exe|
      assert_match "Salvador", shell_output("#{bin}/#{exe} 2>&1")
    end
    assert_match "Hsa167996", shell_output("#{bin}/statal -sident -in #{pkgshare}/dataset/AA1.fas")
  end
end
