class Porechop < Formula
  # cite Wick_2017: "https://doi.org/10.1099/mgen.0.000132"
  desc "Trim adapters of Oxford Nanopore sequencing reads"
  homepage "https://github.com/rrwick/Porechop"
  url "https://github.com/rrwick/Porechop/archive/v0.2.4.tar.gz"
  sha256 "44b499157d933be43f702cec198d1d693dcb9276e3c545669be63c2612493299"
  head "https://github.com/rrwick/Porechop"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "34b03ce111f627cf13c8b9d28bd926eae9969690904fccc8cef3b22edbdb1e75" => :sierra
    sha256 "28cc0a48435c306d1efbd82f23b9ea096fa54a8ceb64f109e69637a61921a3da" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/porechop --help")
  end
end
