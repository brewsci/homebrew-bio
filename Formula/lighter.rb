class Lighter < Formula
  # cite Song_2014: "https://doi.org/10.1186/s13059-014-0509-9"
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c8a251c410805f82dad77e40661f0faf14ec82dedb3ff717094ba8ff4ef94465"
  license "GPL-3.0-or-later"
  head "https://github.com/mourisl/Lighter.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03506e43e44d01b4173a3e658b2c8e52f5a6c3630722d0cab0e7abd28aa69ba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ded135f9d425613f1e47a4fbc5e7e8f653d91015019da531915c584ba5c9b74"
    sha256 cellar: :any_skip_relocation, ventura:       "12ccdfcfed688434e2e779e1374f8471da1b36f3a818431da2887e41b0ffed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c041ad05b6730fd9bd8fdecd813c35a14ce24d5c8c0438f2ec9fb913f4e7f3e8"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "lighter"
  end

  test do
    assert_match "num_of_threads", shell_output("#{bin}/lighter -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/lighter -v 2>&1")
  end
end
