class Quickmerge < Formula
  # cite Chakraborty_2016: "https://doi.org/10.1093/nar/gkw654"
  desc "Merge long read and short read assemblies"
  homepage "https://github.com/mahulchak/quickmerge"
  url "https://github.com/mahulchak/quickmerge/archive/v0.2.tar.gz"
  sha256 "b1306f595b7746c747d201e0947f95c68792805757dfb654ab2469f6fc091d27"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e74cf28cd0819e7ce718391d0553bf58be562cb73e4828880c6ec0abbac0b874" => :sierra
    sha256 "76d98343d7381db1d97ec39ce91dc082c11bd5588a0f96b031bc4671d5e170fc" => :x86_64_linux
  end

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
