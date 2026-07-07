class Uniqtag < Formula
  # cite Jackman_2015: "https://doi.org/10.1371/journal.pone.0128026"
  desc "Abbreviate strings to short unique identifiers"
  homepage "https://github.com/sjackman/uniqtag"
  url "https://github.com/sjackman/uniqtag/archive/refs/tags/1.0.1.tar.gz"
  sha256 "ead5cc86658ffb928c68501ed3a17608c76fdb7eaf21cd291f88cf4582bf3ea2"
  license "MIT"
  head "https://github.com/sjackman/uniqtag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "61be621e022719a2fec273ce9a565509a915f7d7fd32723439e986d7d60b724b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "31ab9e9aee63b3629d0839afb37694094dfdc9fb97b16e7b2346375b332e1ec6"
  end

  uses_from_macos "ruby"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uniqtag --version 2>&1")
  end
end
