class Oarfish < Formula
  # cite Gleeson_2022: "https://doi.org/10.1093/nar/gkab1129"
  # cite Zare_2024: "https://doi.org/10.1101/2024.02.28.582591"
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5a00e6a0c9ec54e3710a943af72bd61d73203aa33d94f9df728025eb004e4ea8"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f6a526bc7ebc6682ab8c203eba23f71d7c03eb9897b3a05150118d214e12ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ff3c1cbc0dc6e2fbda0e3361d6919535da1160b2d1b3e0ba4a6ff3eba74b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c78c3f0540fdd8c69e4feae4a38687b3427850d6348132aa6bdf7574c6959f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdd42baf745fa3046881d911733dba2b46194cf10ca88bc937d4d2579acc768"
  end

  depends_on "rust" => :build
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "oarfish #{version}", shell_output("#{bin}/oarfish --version")
  end
end
