class Quickmerge < Formula
  # cite Chakraborty_2016: "https://doi.org/10.1093/nar/gkw654"
  desc "Merge long read and short read assemblies"
  homepage "https://github.com/mahulchak/quickmerge"
  url "https://github.com/mahulchak/quickmerge/archive/refs/tags/v0.3.tar.gz"
  sha256 "13169366bdaeef5462bda35dd3c213d8ec818db8f34c173ac336d5ce98ac92b3"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "dac4d13b6bce25546570e2302721ca3b26c6c99fd1e13d189d5ee4c79d0259cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "980b2b1f9113b394deac9ddb5ce0acf978d19a5ce57b7d8e80bbec28a744f8ff"
  end

  depends_on "mummer"

  def install
    system "make", "-C", "merger"
    bin.install "merger/quickmerge"
    bin.install "merge_wrapper.py" => "quickmerge_wrapper.py"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/quickmerge 2>&1", 1)
  end
end
