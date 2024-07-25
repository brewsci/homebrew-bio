class AlevinFry < Formula
  # cite He_2022: "https://doi.org/10.1038/s41592-022-01408-3"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6c6becd07f63794d63fdf7c40f56289f01de093c403db3b593f72312cb2617bc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ea5c9c6ef1adecf97875211fab2bdd4eca3175ebc693d1c5a5702867d6e6abda"
    sha256 cellar: :any_skip_relocation, ventura:      "ae61f6c811a3daec4a5590285a2f93c6b6f05524fc3402da60c5dfbdd92568f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "14789b61015dd5db0f129efbd7864dda49530694226c851464bba6feea1bbd87"
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
