class Samclip < Formula
  desc "Filter soft/hard clipped alignments from SAM files"
  homepage "https://github.com/tseemann/samclip"
  url "https://github.com/tseemann/samclip/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8196b705b0319b168949f42818eb3a6bcf96119a24daa950fa0d908d3111d127"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "7e53a56211ca0080b6d656e7362fe3389d303b94eec05ea4b66c61083cb4e3ab"
    sha256 cellar: :any_skip_relocation, ventura:      "7e53a56211ca0080b6d656e7362fe3389d303b94eec05ea4b66c61083cb4e3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa6e252b0d41c34b3745d991d702681721d70c887a7576ca66d1365f724802d4"
  end

  def install
    bin.install "samclip"
    pkgshare.install Dir["test.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samclip --version")
    t = pkgshare/"test"
    assert_match "Done.",
      shell_output("#{bin}/samclip --ref #{t}.fna < #{t}.sam 2>&1 > /dev/null")
  end
end
