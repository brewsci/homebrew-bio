class Oarfish < Formula
  # cite Gleeson_2022: "https://doi.org/10.1093/nar/gkab1129"
  # cite Zare_2024: "https://doi.org/10.1101/2024.02.28.582591"
  desc "Long read RNA-seq quantification"
  homepage "https://github.com/COMBINE-lab/oarfish"
  url "https://github.com/COMBINE-lab/oarfish/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "78b523fc459fec5ae3680395925862b4d367bd56d051120f28c689dd387e1758"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/oarfish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "a4ed4db4cfbf3e85bfd97019fa4ff4189ea7663db6e7760649a187c2a53d95f5"
    sha256 cellar: :any_skip_relocation, ventura:      "ed4f5a8cba19e51fa329ec89240d80bf65f052d1d3db74a533b67193f12acfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "56ef87ec8fe9a87c1feffaf387c177456c0a2a04162712680d23a11e36ca70f7"
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
