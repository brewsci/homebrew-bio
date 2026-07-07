class Tantan < Formula
  # cite Frith_2011: "https://doi.org/10.1093/nar/gkq1212"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://gitlab.com/mcfrith/tantan"
  url "https://gitlab.com/mcfrith/tantan/-/archive/51/tantan-51.tar.gz"
  sha256 "f25db9441409d526becfb10df7a610c10d0e5f163d58b21535e4f045bcfc118f"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/mcfrith/tantan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3c65534e2fe582a10e9f8d815d238643d5df0b706681e35fcf30e3c7c8118d38"
    sha256 cellar: :any_skip_relocation, ventura:      "df806da047b3215dc87620252fda2099ae783f16655874128058065040f7ec99"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba52222561bcd666820de2a208ec32f9725140480f3fc5b8da2527a20184b8dd"
  end

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "-msse4", ""
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/tantan --help")
    cp_r pkgshare/"test", testpath
    cd "test" do
      system "./tantan_test.sh"
    end
  end
end
