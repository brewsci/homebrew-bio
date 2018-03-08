class Porechop < Formula
  desc "Trim adapters of Oxford Nanopore sequencing reads"
  homepage "https://github.com/rrwick/Porechop"
  url "https://github.com/rrwick/Porechop/archive/v0.2.3.tar.gz"
  sha256 "bfed39f82abc54f44fffd9b13d2121868084da7ac3d158ac9b9aa6fa0257f0f4"
  head "https://github.com/rrwick/Porechop"

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/porechop --help")
  end
end
