class Gfaview < Formula
  desc "Manipulate an assembly graph in GFA format"
  homepage "https://github.com/lh3/gfa1"
  url "https://github.com/lh3/gfa1/archive/2faeed2953399102e8bb22f5aa833c8f900a7587.tar.gz"
  version "0.0.53"
  sha256 "0f12908a48ad7d9b3fd7b9b32d0d3c8fa2c672c14317085c7a5fb96aef18a4b5"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "4de911f9d841fcaf3fdd7cfb1069dc325b5eb21917a582a0c9fac4bff351df2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d1937935c3ac96c9cc46ed1b2186c2d3968d99d648890c65fc9eb17e1d44721f"
  end

  # See https://github.com/brewsci/homebrew-bio/pull/1242
  deprecate! date: "2021-01-09", because: :repo_archived

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "gfaview"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gfaview 2>&1", 1)
  end
end
