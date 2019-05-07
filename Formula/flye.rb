class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.4.2.tar.gz"
  sha256 "5b74d4463b860c9e1614ef655ab6f6f3a5e84a7a4d33faf3b29c7696b542c51a"
  head "https://github.com/fenderglass/Flye.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0c7bd2671ba277214d9691790b90b67bdd45a844cb4427d4c859f9515c9da19d" => :sierra
    sha256 "5449ddd8d6237f7a4286ccf6740ab1afcf696492d91d0b30a8883a529132d59a" => :x86_64_linux
  end

  depends_on "python@2"

  def install
    system "python2", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
