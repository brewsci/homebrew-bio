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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9cf1bd40db8050ec69ba70c9e7b7169c3752205bb9dcbc21326bf8aa81496d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cab7d111232a560963f4b05d75e4c3d52ed38de91c136735cf5410124ccb294e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39aeb41ad9d04e9a3e3a0b0c221f9d49715a0bad0fc86d71179e7a24535546c0"
    sha256 cellar: :any,                 x86_64_linux:  "8bac1f8857a87a7eb783f7e20263142114bce13b16f2b3abfefa7130fb9b5c28"
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
