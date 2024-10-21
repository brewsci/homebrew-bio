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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c05dbf8857ec513e25ab9ebb608ff427629e39eadb0c23f2a5a6e17808f489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5106eaee0421cc51ba56b26c81c2b088db6d73918bc8710f8a566395bed51962"
    sha256 cellar: :any_skip_relocation, ventura:       "5ca526ec6bf6105a6c6e80940741f4a2efb48d805d94a290e09b4282650df4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78f983a2c16dd5077c338e6c75edbc88f8234e353fca4722ea4b06841c278d5"
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
