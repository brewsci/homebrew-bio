class AlevinFry < Formula
  # cite Zakeri_2021: "https://doi.org/10.1101/2021.02.10.430656"
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://alevin-fry.readthedocs.io"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "407a1b5767a293aefa9ff1dc2eda478356e74d148e3bfa89ef58213340e87ae2"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "fcefc4ca295178d0069934d8227c488ea06fbe473efb50dbbc72a300b800298c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "942c9e2b42cb2e6ea640f0f6c7daa829c0cff991fce0a516823d20b734d337fd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/alevin-fry --help")
  end
end
