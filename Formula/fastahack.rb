class Fastahack < Formula
  desc "Utilities for indexing and sequence extraction from FASTA files"
  homepage "https://github.com/ekg/fastahack"
  url "https://github.com/ekg/fastahack.git",
    tag: "v1.0.0", revision: "bb332654766c2177d6ec07941fe43facf8483b1d"

  def install
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="

    prefix.install "tests" => "test"
  end

  test do
    cp_r Dir[prefix/"test/*"], testpath

    system opt_bin/"fastahack", "correct.fasta"
  end
end
