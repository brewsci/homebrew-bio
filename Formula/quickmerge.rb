class Quickmerge < Formula
  # cite Chakraborty_2016: "https://doi.org/10.1093/nar/gkw654"
  desc "Merge long read and short read assemblies"
  homepage "https://github.com/mahulchak/quickmerge"
  url "https://github.com/mahulchak/quickmerge/archive/v0.2.tar.gz"
  sha256 "b1306f595b7746c747d201e0947f95c68792805757dfb654ab2469f6fc091d27"

  depends_on "mummer"
  depends_on "python@2"

  def install
    system "make", "-C", "merger"
    bin.install "merger/quickmerge"
    bin.install "merge_wrapper.py" => "quickmerge_wrapper.py"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/quickmerge 2>&1", 1)
  end
end
