class Nanopolish < Formula
  # cite Loman_2015: "https://doi.org/10.1038/nmeth.3444"
  desc "Signal-level algorithms for MinION data"
  homepage "https://github.com/jts/nanopolish"
  url "https://github.com/jts/nanopolish.git",
      tag:      "v0.13.2",
      revision: "46b65bbabf670ea42a9e446540a6e81efc2e4c58"
  license "MIT"
  head "https://github.com/jts/nanopolish.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "96585ee4d83de6848fcb18f15499b07bc90bb3b1dec358aa1040d307d2c64df3"
    sha256 cellar: :any, x86_64_linux: "024891195b39013008a3a2d03946617697602335077d36930e975091232ca8b8"
  end
  
  depends_on "wget" => :build

  def install
    system "make"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanopolish --version")
    assert_match "extracted 1 read",
                 shell_output("#{bin}/nanopolish extract -o out.fasta \
                    #{pkgshare}/test/data/LomanLabz_PC_Ecoli_K12_R7.3_2549_1_ch8_file30_strand.fast5 2>&1")
    assert_match ">channel_8_read_24", File.read("out.fasta")
  end
end
