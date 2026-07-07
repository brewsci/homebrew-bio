class RtgTools < Formula
  # cite Cleary_2015: "https://doi.org/10.1101/023754"
  desc "Easily manipulate and accurately compare multiple VCF files"
  homepage "https://www.realtimegenomics.com/products/rtg-tools"
  url "https://github.com/RealTimeGenomics/rtg-tools/releases/download/3.13/rtg-tools-3.13-nojre.zip"
  sha256 "bc5c6badb07d7e20d1c5c557bd6d571a022bbd9f58fa1e3840bcff9431a18f96"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3683263aebac60afff0745f90a3936131281373d58ba630a197c42034fac3f1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3683263aebac60afff0745f90a3936131281373d58ba630a197c42034fac3f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3683263aebac60afff0745f90a3936131281373d58ba630a197c42034fac3f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e0409242ad55adfc6cd8cecabd299823177f7d7f1d42b9db34f0c5406ec0ce"
  end

  depends_on "openjdk"

  def install
    # avoid question about sending stats back to base
    (prefix/"rtg.cfg").write "RTG_TALKBACK=false\n"
    rm "rtg.bat"
    bin.install_symlink "../rtg"
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtg version")
  end
end
