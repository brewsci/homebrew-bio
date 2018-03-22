class Porechop < Formula
  desc "Trim adapters of Oxford Nanopore sequencing reads"
  homepage "https://github.com/rrwick/Porechop"
  url "https://github.com/rrwick/Porechop/archive/v0.2.3.tar.gz"
  sha256 "bfed39f82abc54f44fffd9b13d2121868084da7ac3d158ac9b9aa6fa0257f0f4"
  head "https://github.com/rrwick/Porechop"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7d81f81db5155d7016b5e414a5102ba007ec77f9f2ccf0249f33fe39fab1fc29" => :sierra_or_later
    sha256 "3473f4445a1b115180780fb0744a747388c1fd663b0be3633008e51793da9e9e" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/porechop --help")
  end
end
