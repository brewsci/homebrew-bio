class Breseq < Formula
  # Deatherage_2014: "https://doi.org/10.1007/978-1-4939-0554-6_12"
  desc "Find mutations in microbes from short reads"
  homepage "https://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.37.1/breseq-0.37.1-Source.tar.gz"
  sha256 "96131a55271225f7d7e130ef25adea04608dc8e142d2268c85be627c761fcd1b"
  head "https://github.com/barricklab/breseq.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, big_sur:      "ddae4324ddf2115371a2b7a0ebd8fa58601a866d564219e380a43227a72f8fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "223054d348e87ce188f24b173c22b3dd51bc5dc247269537838a95375e988a0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bowtie2"
  depends_on "r"

  uses_from_macos "gzip"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-libunwind"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/breseq --version 2>&1")
    assert_match "regardless", shell_output("#{bin}/breseq -h 2>&1", 255)
  end
end
