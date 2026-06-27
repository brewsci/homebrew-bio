class Bandage < Formula
  # cite Wick_2015: "https://doi.org/10.1093/bioinformatics/btv383"
  desc "Bioinf App for Navigating De novo Assembly Graphs Easily"
  homepage "https://rrwick.github.io/Bandage/"
  url "https://github.com/rrwick/Bandage/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "04de8152d8bf5e5aa32b41a63cf1c23e1fee7b67ccd9f1407db8dc2824ca4e30"
  license "GPL-3.0-only"

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
