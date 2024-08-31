class Oarfish < Formula
  # cite Gleeson_2022: "https://doi.org/10.1093/nar/gkab1129"
  # cite Zare_2024: "https://doi.org/10.1101/2024.02.28.582591"
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "78b523fc459fec5ae3680395925862b4d367bd56d051120f28c689dd387e1758"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

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
