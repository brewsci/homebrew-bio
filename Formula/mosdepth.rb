class Mosdepth < Formula
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/releases/download/v0.2.9/mosdepth"
  sha256 "a73283fb1a7465601a4d2d738f6f832f2fd84bf9181e0d4d2b91453da385177c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3f26c70c2d74e872b3b925ad5701cb3c39d9b7b216fda9cad5f436c7967bd91e" => :x86_64_linux
  end

  depends_on :linux

  def install
    bin.install "mosdepth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
    assert_match "BAM-or-CRAM", shell_output("#{bin}/mosdepth -h 2>&1")
  end
end
