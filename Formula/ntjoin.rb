class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.4/ntJoin-1.0.4.tar.gz"
  sha256 "3d369ddc67573281cfe2361252f6839e5f0bfd110bbee0f13f2e3508a041800c"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "7e770fb38403ea191a5a9e1d10de0ef4eb214eaea7afe39811a2b94121bb4fff" => :catalina
    sha256 "9c7b5396ee17176d074a4dcfdb0d31221f066068298bcccc615b959ed2557c9a" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "numpy"
  depends_on "python@3.8"
  depends_on "samtools"
  depends_on "scipy"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "make", "-C", "src"
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "requirements.txt", "python-igraph", "python-igraph==0.7.1.post6"
    inreplace "bin/ntjoin_assemble.py", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install "ntJoin"
    libexec_src = Pathname.new("#{libexec}/bin/src")
    libexec_src.install "src/indexlr"
    libexec_bin = Pathname.new("#{libexec}/bin/bin")
    libexec_bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntJoin help")
  end
end
