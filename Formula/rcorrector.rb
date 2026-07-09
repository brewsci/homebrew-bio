class Rcorrector < Formula
  # cite Song_2015: "https://doi.org/10.1186/s13742-015-0089-y"
  desc "Error correction for Illumina RNA-seq reads"
  homepage "https://github.com/mourisl/Rcorrector"
  url "https://github.com/mourisl/Rcorrector/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "cc1a9e82056bdc717b7ac40729c90573caad371899f9a1c61c25b50f019fbedb"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "20c9a683be2b9e6c3cc632bd2f3ebf38168abed6b6c0f1e157949b5cdee6c7a2"
    sha256 cellar: :any, arm64_sequoia: "f6d13b205917fa7cf3e57e338325f19d7a017117e4c0bd9de0eb56a33225015e"
    sha256 cellar: :any, arm64_sonoma:  "50fd4823dc5e6b136688234616bc515c0ee683032f935f9141e7fe5ede203636"
    sha256 cellar: :any, x86_64_linux:  "699cca065365141a7fc0069d88a7a10d4661c79df6c7e44380ba8d16b7e88f10"
  end

  depends_on "jellyfish"
  depends_on "zlib-ng-compat"

  def install
    system "make"
    bin.install "rcorrector", "run_rcorrector.pl"
    doc.install "LICENSE", "README.md", "Sample"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/rcorrector 2>&1")
    assert_match "Usage", shell_output("#{bin}/run_rcorrector.pl 2>&1", 255)
  end
end
