class Breseq < Formula
  # Deatherage_2014: "https://doi.org/10.1007/978-1-4939-0554-6_12"
  desc "Find mutations in microbes from short reads"
  homepage "https://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5aa1bd9af71899e1358cfb9b8440c16cc908f185d9178a401a5a4d3f0c7ee861"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later"]
  head "https://github.com/barricklab/breseq.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "04ed3f727686f7ed67101cd0c1832d0dc2cc57bc35fc50272cfb9cdbb03f4134"
    sha256 cellar: :any_skip_relocation, ventura:      "c3dbfc70ba65b0151232a76f184c302113ed41f7492db1cb2d512f1dd93dfa7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "12a0d972e0214c34e1f4c27e7785fe4066efda2f6b758b6c1304f9bfdc645682"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "bowtie2"
  depends_on "r"

  uses_from_macos "gzip"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "llvm"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/breseq --version 2>&1")
    assert_match "regardless", shell_output("#{bin}/breseq -h 2>&1", 255)
  end
end
