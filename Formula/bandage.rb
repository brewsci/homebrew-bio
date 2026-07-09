class Bandage < Formula
  # cite Wick_2015: "https://doi.org/10.1093/bioinformatics/btv383"
  desc "Bioinf App for Navigating De novo Assembly Graphs Easily"
  homepage "https://rrwick.github.io/Bandage/"
  url "https://github.com/rrwick/Bandage/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "04de8152d8bf5e5aa32b41a63cf1c23e1fee7b67ccd9f1407db8dc2824ca4e30"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256               arm64_tahoe:   "9a6d7c5b8d5511734f9b50ce7620bac4656db1c81a2d64584e569ff580ecb65f"
    sha256               arm64_sequoia: "1fc05c3f394487a8ac95aca1dfc40bd1af1f7c597e544baaa456fcf52c4b02dc"
    sha256               arm64_sonoma:  "9221b0870e852863fed5e9c4bf35eaa0cf81d49b888a30cafd162bf86e443be4"
    sha256 cellar: :any, x86_64_linux:  "402e6ad9f6cbe07c6269f70fa4b9928aec06bfbd4c48c51d77f44f5aeafd1f7f"
  end

  depends_on "qt@5"

  def install
    # Build a plain executable (not a macOS .app bundle) so the CLI is usable
    # the same way on every platform.
    system formula_opt_bin("qt@5")/"qmake", "Bandage.pro", "CONFIG-=app_bundle"
    system "make", "-j#{ENV.make_jobs}"
    bin.install "Bandage" => "bandage"
    pkgshare.install "build_scripts/sample_LastGraph"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    assert_match "Usage", shell_output("#{bin}/bandage --help")
  end
end
