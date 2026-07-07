class Souporcell < Formula
  # cite Heaton_2019: "https://www.biorxiv.org/content/10.1101/699637v1"
  desc "Clustering scRNAseq by genotypes"
  homepage "https://github.com/wheaton5/souporcell"
  url "https://github.com/wheaton5/souporcell/archive/refs/tags/3.0.tar.gz"
  sha256 "6d2e3b4b7a33cd266e56ecb477ee5311567e9bcc91e9f60301e730ab46e28de6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "221e7180c2c8926a29b9a2fab1232f99897d19a5e067d366b3dc85ce0d892eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e8172d1d52d3c5b3ce6efb204f44028722f1ef4a6bfc25c9ed49e88896172a65"
  end

  depends_on "rust" => :build

  def install
    ENV["CARGO_INCREMENTAL"] = "0"
    cd "souporcell" do
      system "cargo", "install", "--root=#{prefix}", "--path=."
    end
    cd "troublet" do
      system "cargo", "install", "--root=#{prefix}", "--path=."
    end
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/souporcell --help")
    assert_match "USAGE", shell_output("#{bin}/troublet --help")
  end
end
