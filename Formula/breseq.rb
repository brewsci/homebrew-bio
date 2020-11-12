class Breseq < Formula
  # Deatherage_2014: "https://doi.org/10.1007/978-1-4939-0554-6_12"
  desc "Find mutations in microbes from short reads"
  homepage "https://barricklab.org/twiki/bin/view/Lab/ToolsBacterialGenomeResequencing"
  url "https://github.com/barricklab/breseq/releases/download/v0.35.4/breseq-0.35.4-Source.tar.gz"
  sha256 "762f7b6aac26bddb5a39724e103267bd48d597d74fa7a8006d2bf0bd68fe86b4"
  head "https://github.com/barricklab/breseq.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "332352bb4d28e1074f4421aa68262cbc378c34e320dd5d6415c93fc91d54e126" => :catalina
    sha256 "bc033dd9a09e76e1bdacbdb1cc357e755cece4063226d254e5b601297dc02287" => :x86_64_linux
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
