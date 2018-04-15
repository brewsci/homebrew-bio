class Clonalframeml < Formula
  # cite Didelot_2015: "https://doi.org/10.1371/journal.pcbi.1004041"
  desc "Efficient Inference of Recombination in Bacterial Genomes"
  homepage "https://github.com/xavierdidelot/ClonalFrameML"
  url "https://github.com/xavierdidelot/ClonalFrameML/archive/v1.11.tar.gz"
  sha256 "395e2f14a93aa0b999fa152d25668b42450c712f3f4ca305b34533317e81cc84"
  head "https://github.com/xavierdidelot/ClonalFrameML.git"

  def install
    cd "src" do
      exe = "ClonalFrameML"
      # https://github.com/xavierdidelot/ClonalFrameML/issues/56
      File.write("version.h", "#define ClonalFrameML_GITRevision #{version}\n")
      system ENV.cxx, "-O3", "main.cpp", "-o", exe, "-I.", "-Imyutils", "-Icoalesce"
      bin.install exe
    end
  end

  test do
    assert_match "recombination", shell_output("#{bin}/ClonalFrameML -h 2>&1", 13)
  end
end
