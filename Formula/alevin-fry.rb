class AlevinFry < Formula
  # cite Zakeri_2021: "https://doi.org/10.1101/2021.02.10.430656"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "20572fffc8001a7d41ab8eb2af8cdb09b0443379ff6f9d4ef5a092c7db9fd265"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/alevin-fry --help")
  end
end
