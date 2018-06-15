class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1101/304253"
  desc "Correct misassemblies using linked reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/archive/1.1.2.tar.gz"
  sha256 "c103f1fa50e124dbee16abb97650b8f006877de5852a67dc8f5a42642effbb58"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "4c83fedfc8e30014c0765a1acd66ff5a35572e37d0976c01f31ea6418d6f4963" => :sierra_or_later
    sha256 "8eb4f7eda64705b2fa02d272a49e7ad66ca439d29e6e5ccf010e8c45dd8da0ed" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "python"

  def install
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => Dir[libexec/"lib/python*/site-packages"].first
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tigmint --help")
    assert_match "usage", shell_output("#{bin}/tigmint-cut --help")
    assert_match "usage", shell_output("#{bin}/tigmint-molecule --help")
  end
end
