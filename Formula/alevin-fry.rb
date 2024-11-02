class AlevinFry < Formula
  # cite He_2022: "https://doi.org/10.1038/s41592-022-01408-3"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6c6becd07f63794d63fdf7c40f56289f01de093c403db3b593f72312cb2617bc"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ed29788ff60c08ebb1d134a278c3e5b869618b2983a2c230d16c154a64470c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d071dea06c2e7ad784a5aaeaa44e39049fedaa1e5995f7cb17ce08a9163e506e"
    sha256 cellar: :any_skip_relocation, ventura:       "fe6fe11978cea7f1d8307856389eb1e9e79fcb0a13049784a62b8d8d402eb5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c2c1efd44c6597528376d2b91e3397ecde879e30ec5b567258f274f0d1f9314"
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
