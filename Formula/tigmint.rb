class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/releases/download/v1.2.5/tigmint-1.2.5.tar.gz"
  sha256 "15a56748f19732462c0445fe9df2f737a4bf8caa97dbc0fe6e943e3fd1c6b5f0"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "c9a02a3a6135558085208ecb15cb6f020167fa6c5f1e6de7e916229c347f010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c18ce3b04b79bd63cd55884671006fccab5b9a618b5d72e86c8825b89d8bc87d"
  end

  depends_on "bedtools"
  depends_on "minimap2"
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "samtools"

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "bin/tigmint-cut", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    inreplace "bin/tigmint_molecule.py", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    inreplace "bin/tigmint_molecule_paf.py", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt", "--no-binary=pysam"
    bin.install Dir["bin/*"]
    system "make", "-C", "src"
    libexec_src = Pathname.new("#{libexec}/src")
    libexec_src.install "src/long-to-linked-pe"
    bin.env_script_all_files libexec/"bin", PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tigmint --help")
    assert_match "usage", shell_output("#{bin}/tigmint-cut --help")
    assert_match "usage", shell_output("#{bin}/tigmint_molecule.py --help")
    assert_match "usage", shell_output("#{bin}/tigmint_molecule_paf.py --help")
  end
end
