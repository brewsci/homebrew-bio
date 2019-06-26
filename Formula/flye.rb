class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.4.2.tar.gz"
  sha256 "5b74d4463b860c9e1614ef655ab6f6f3a5e84a7a4d33faf3b29c7696b542c51a"
  head "https://github.com/fenderglass/Flye.git", :branch => "flye"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "81c0c105ee8b6316288cb01371e7b62a182acb1a3a673b4e8f3681a424a21a8c" => :sierra
    sha256 "e7c259f6390516d752b5c51d25b75982f896fc18c1cbd4edbb8f7ee33e717bad" => :x86_64_linux
  end

  depends_on "python@2"

  def install
    system "python2", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
