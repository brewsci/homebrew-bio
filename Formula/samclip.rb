class Samclip < Formula
  desc "Filter soft/hard clipped alignments from SAM files"
  homepage "https://github.com/tseemann/samclip"
  url "https://github.com/tseemann/samclip/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "8196b705b0319b168949f42818eb3a6bcf96119a24daa950fa0d908d3111d127"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f1eef22d3337796057f2f1fd45b63a893b408bc543ebd740a0869d7bf98a4280"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10ed4d3fb055a47767520c453b4952dcaca8dc734784e05749c24f3d59ebc695"
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
