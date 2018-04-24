class Gfalint < Formula
  desc "Check a GFA file for syntax errors"
  homepage "http://sjackman.ca/gfalint/"
  url "https://github.com/sjackman/gfalint/releases/download/1.0.0/gfalint-1.0.0.tar.gz"
  sha256 "0db8d5b8f1379bcb76ccc3c7e72d933b7f4f865aa63fe60d4603a6057b18bede"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    Dir[doc/"examples/*.gfa"].each do |f|
      assert_equal "", shell_output("#{bin}/gfalint #{f}")
    end
  end
end
