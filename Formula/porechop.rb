class Porechop < Formula
  # cite Wick_2017: "https://doi.org/10.1099/mgen.0.000132"
  desc "Trim adapters of Oxford Nanopore sequencing reads"
  homepage "https://github.com/rrwick/Porechop"
  url "https://github.com/rrwick/Porechop/archive/v0.2.4.tar.gz"
  sha256 "44b499157d933be43f702cec198d1d693dcb9276e3c545669be63c2612493299"
  head "https://github.com/rrwick/Porechop"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9582147a653c87fb61b94ef8f001da7d45455a87f445297bc7020520cb1be319" => :sierra
    sha256 "7f19dfbdbc11a540a7b1760b41781ac4456299db8bbe707575f9c7a8f4674358" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/porechop --help")
  end
end
