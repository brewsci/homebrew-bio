class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.8/ntJoin-1.0.8.tar.gz"
  sha256 "371f0f922b7f80dd9e3c5a6d57f97c0f16b6b705eecaa6e150afe6f6a10d0897"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "d6593fd8196195d07d6566cdcf7158cf0d6bdc4daa54c38f2b75c5ec13dea109"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e680f9301f7469784959cbf3aa39c882de413f74afdbdb3142e8e5808a4e7b3"
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
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt", "--no-binary=pysam"
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
