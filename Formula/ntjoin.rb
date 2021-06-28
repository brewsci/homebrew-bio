class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.7/ntJoin-1.0.7.tar.gz"
  sha256 "5b9e7d7fec3d23fac9c43a7069170e3ea3cc813c7722ad6bfdcd0f6c8e51a291"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "e5b0830a1932e804b8efbd4d5be6b748a2739c9f7bd9fc53f0731bd4cc18c8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "322a2bd3ea0edf6b1c66cc5f4ea8df0419c3bdc9cc011ea6e3114664523a86c8"
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
