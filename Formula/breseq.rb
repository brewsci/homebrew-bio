class Breseq < Formula
  # Deatherage_2014: "https://doi.org/10.1007/978-1-4939-0554-6_12"
  desc "Find mutations in microbes from short reads"
  homepage "https://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.35.2/breseq-0.35.2-Source.tar.gz"
  sha256 "ad9529a4a8f52e71df2e5386e8b39a66610835dcf9cbc8cec706791c2593ef4d"
  head "https://github.com/barricklab/breseq.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d3b5cdafaf233010db1c38aac445dc24f14a4b4dff58cd3a85b78f9e29c97575" => :catalina
    sha256 "9c37da9a107e947404ad87ba57688ad3247f51696a7f2cf3bc197910a2e11d60" => :x86_64_linux
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
