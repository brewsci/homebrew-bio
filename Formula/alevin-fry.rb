class AlevinFry < Formula
  # cite He_2022: "https://doi.org/10.1038/s41592-022-01408-3"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6c6becd07f63794d63fdf7c40f56289f01de093c403db3b593f72312cb2617bc"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Usage", shell_output("#{bin}/alevin-fry --help")
  end
end
