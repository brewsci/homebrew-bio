class Clonalframeml < Formula
  # cite Didelot_2015: "https://doi.org/10.1371/journal.pcbi.1004041"
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  url "https://github.com/xavierdidelot/ClonalFrameML/archive/v1.12.tar.gz"
  sha256 "ef76705c1a0f1343184f956cd0bdc96c2cfdbb998177330b09b6df84c74c2de6"
  head "https://github.com/xavierdidelot/ClonalFrameML.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "061350e7413c704eb627d28ee9cc391d1e031b0f6e4a9323900ce12d356a1fa1" => :sierra
    sha256 "3555d42efc067ca6eb62dee08ca5981b939e00aaeaaa59d9598eff5aa621bc51" => :x86_64_linux
  end

  def install
    system "make", "-C", "src"
    bin.install "src/ClonalFrameML"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ClonalFrameML -version 2>&1")
    assert_match "recombination", shell_output("#{bin}/ClonalFrameML -h 2>&1")
  end
end
