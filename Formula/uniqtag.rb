class Uniqtag < Formula
  # Jackman_2014: "https://doi.org/10.1101/007583"
  desc "Abbreviate strings to short unique identifiers"
  homepage "https://github.com/sjackman/uniqtag"
  url "https://github.com/sjackman/uniqtag/archive/1.0.tar.gz"
  sha256 "8ff0dd850c15ff3468707ae38a171deb6518866a699964a1aeeec9c90ded7313"
  head "https://github.com/sjackman/uniqtag.git"

  depends_on "ruby" unless OS.mac?

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uniqtag --version 2>&1")
  end
end
