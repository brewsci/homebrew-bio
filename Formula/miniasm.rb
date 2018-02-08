class Miniasm < Formula
  # cite Li_2016: "https://doi.org/10.1093/bioinformatics/btw152"
  desc "Ultrafast de novo assembly for long noisy reads"
  homepage "https://github.com/lh3/miniasm"
  url "https://github.com/lh3/miniasm/archive/v0.2.tar.gz"
  sha256 "177cbb93dbdd3da73e3137296f7822ede830af10339aa7f84fc76afab95a1be6"
  head "https://github.com/lh3/miniasm.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "dbc894c4fbc31b8694777654b4df0e1ce74aff4ef20699c5541a7382f697f475" => :sierra_or_later
    sha256 "db65b66443d72a14d80e228874b9d906e536c52915b7a8d0670b6e9ee96df90d" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "miniasm", "minidot"
    pkgshare.install "misc"
  end

  test do
    assert_match "in.paf", shell_output("#{bin}/miniasm 2>&1", 1)
  end
end
