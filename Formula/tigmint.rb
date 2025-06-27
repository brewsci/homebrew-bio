class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/releases/download/v1.2.3/tigmint-1.2.3.tar.gz"
  sha256 "6bc72e23de660a0ad3042eeedb9a2b57ffef86c94dadeaaf926c582b458dd297"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "2c8d98f0d9180641c0ed6a37ef5462b4aa532be2de7449d932aa145f7fcb9ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ab6f031d9ab16c78a936491906c892b88d1c1912fc1877cdf2caf4313ee14ee8"
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
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
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
