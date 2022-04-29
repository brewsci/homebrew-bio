class Fastahack < Formula
  desc "Utilities for indexing and sequence extraction from FASTA files"
  homepage "https://github.com/ekg/fastahack"
  url "https://github.com/ekg/fastahack.git",
    tag: "v1.0.0", revision: "bb332654766c2177d6ec07941fe43facf8483b1d"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "1e793a15227eb4c82401ecaa17c363514dd00785df5c50519b401621ebc47a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ebe9dcf4f3974bbfe2c6d96a90c0c3166c6df4b5383390620885b26bbf0dc62"
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="

    prefix.install "tests" => "test"
  end

  test do
    cp_r Dir[prefix/"test/*"], testpath

    system bin/"fastahack", "correct.fasta"
  end
end
