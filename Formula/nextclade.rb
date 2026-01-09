class Nextclade < Formula
  desc "Viral genome alignment, mutation calling, clade assignment & quality checks"
  homepage "https://clades.nextstrain.org"
  url "https://github.com/nextstrain/nextclade/archive/refs/tags/1.2.3.tar.gz"
  sha256 "4f0f71df7c26d03f7b5898cd01d0ab30029c46de505ec805f96abee09f8f231a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "coreutils" => :build
  depends_on "make" => :build

  def install
    system "make", "prod"
    # bin.install ".out/bin/nextalign-MacOS-x86_64" => "nextalign"
    # bin.install ".out/bin/nextclade-MacOS-x86_64" => "nextclade"
    bin.install Dir[".out/bin/nextalign-*"].first => "nextalign"
    bin.install Dir[".out/bin/nextclade-*"].first => "nextclade"
  end

  test do
    assert_match "nextalign #{version}", shell_output("#{bin}/nextalign -h")
    assert_match "nextclade #{version}", shell_output("#{bin}/nextclade -h")
  end
end
