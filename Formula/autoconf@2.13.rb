class AutoconfAT213 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
  sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41331a8f83c8795dd59105d0a83a2eaf2292d2935e0ee28bee7b82ac7d131a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41331a8f83c8795dd59105d0a83a2eaf2292d2935e0ee28bee7b82ac7d131a17"
    sha256 cellar: :any_skip_relocation, ventura:       "0b38704cde337fa5e6ce79b9b2d46e9813a2bcb4bc887b7e649d287c481a6c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "457c1c6c8fb67298f7e557cb6349398c1ae52ad4c6e707a6e3a7f3ec66ab7348"
  end

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-suffix=213",
                          "--prefix=#{prefix}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match "Usage: autoconf", shell_output("#{bin}/autoconf213 --help 2>&1")
  end
end
