class Souporcell < Formula
  # cite Heaton_2019: "https://www.biorxiv.org/content/10.1101/699637v1"
  desc "Clustering scRNAseq by genotypes"
  homepage "https://github.com/wheaton5/souporcell"
  url "https://github.com/wheaton5/souporcell/archive/refs/tags/3.0.tar.gz"
  sha256 "6d2e3b4b7a33cd266e56ecb477ee5311567e9bcc91e9f60301e730ab46e28de6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4adcf8deadfd64e95fa3627ba5b756c0c3618709e721c851f744a755ab09c60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63eecc94da35bd253339a229bd6e5df7cf1349f053610b39a60dc515388e002d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861fbf18753b410c559ec240bf60c38f419afa2d7c4aa820d4ca04d5b69e6432"
    sha256 cellar: :any,                 x86_64_linux:  "32b0550d60eafcab380b41f8cbaf2014bc59cf2070eb5c4afbae0f4aa58e942d"
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
