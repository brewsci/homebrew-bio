class Mosdepth < Formula
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/releases/download/v0.2.3/mosdepth"
  sha256 "0aaeb283b296e5ee0a2d819b4842b92289145ed17a37210144f0e02edd3629c4"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "bb05121fdf75c04bc21a7ea46008eb3309a4d9f52ccbba0bde202605a77f3f28" => :x86_64_linux
  end

  depends_on :linux

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "htslib"
    depends_on "zlib"
  end

  def install
    bin.install "mosdepth"
    unless OS.mac?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/"mosdepth"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
    assert_match "BAM-or-CRAM", shell_output("#{bin}/mosdepth -h 2>&1")
  end
end
