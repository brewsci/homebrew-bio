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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532d4cd2831bf2c8d32e8d47afd41533528bbc32e2bf550fec8f245db7793c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909258cb572ee7d39a69323cffe8fb499fe44c9322b3c99c52486ae1e371a7a2"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab27a2bfc79e94715b92716137a238a6fcf52de3cf28a7d3583e29c0a803e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941555d9390f35db6ecff3945afb254a30af7594ea1fce7184ed4a9bb0ffcaa4"
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
