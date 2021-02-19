class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.6/ntJoin-1.0.6.tar.gz"
  sha256 "d8931400c9d90dd355528be6cfd01b3294ef81875d0a718ded3774735060b96b"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "e3c44075e84098fe741e7077ace402bd89c36b1afcf3ce037f97b52013c8d978"
    sha256               x86_64_linux: "e7d417d1b32ca86a2ba30b6a82d1943362ba56f76b71eb0659f0f419409718c1"
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
