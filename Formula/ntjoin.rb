class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.3/ntJoin-1.0.3.tar.gz"
  sha256 "61b5afce7c38e9763777dc1ca5db3944eb76c64c22d2baf61c5f0383a3a74a9c"
  license "GPL-3.0"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "e72ac6df9db1734acf60f33e810ab209740b95d350a788963e49b6fdd54af497" => :catalina
    sha256 "ea4c57a7950d1643fa39a559d7cb330a3ed8f3605a211c1256d706e91a43198d" => :x86_64_linux
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
