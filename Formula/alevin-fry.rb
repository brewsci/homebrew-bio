class AlevinFry < Formula
  # cite He_2022: "https://doi.org/10.1038/s41592-022-01408-3"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "415106d13a39812ed0e671393480840477ff1a6073dcc794ffb52fa583460906"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8546a0c57d8db34f15dd616677bd30898e545a32fb951c5dc2a312dfd786214c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c564cf03fa17853a007e6fee5f8cbb29d46213f856b7f74ae81731ff923a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a9dbc7cc00af508fd18f258c1c6de7bebf45370a88904973c68575afb27aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e454334e59334abb2c72af6d5deba70d30af2c9be1f034357efeca63ceb34b88"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Usage", shell_output("#{bin}/alevin-fry --help")
  end
end
