class Tigmint < Formula
  include Language::Python::Shebang

  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/releases/download/v1.2.10/tigmint-1.2.10.tar.gz"
  sha256 "8e7b5d424ff69d5da7b117bef9996463b02205078ce0fb6e3074ca6c9933efa9"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/tigmint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "c9a02a3a6135558085208ecb15cb6f020167fa6c5f1e6de7e916229c347f010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c18ce3b04b79bd63cd55884671006fccab5b9a618b5d72e86c8825b89d8bc87d"
  end

  depends_on "bedtools"
  depends_on "btllib"
  depends_on "minimap2"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "samtools"

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    python = formula_opt_bin("python@3.14")/"python3.14"
    xy = Language::Python.major_minor_version python
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    # btllib is provided by Homebrew (its PyPI pin is unsatisfiable on modern
    # Python) and numpy comes from the numpy formula; drop both from the pip list.
    inreplace "requirements.txt" do |s|
      s.gsub!(/^btllib\b.*\n/, "")
      s.gsub!(/^numpy\b.*\n/, "")
    end
    system python, "-m", "pip", "install", "--prefix=#{libexec}",
           "-r", "requirements.txt", "--no-binary=pysam"
    bin.install Dir["bin/*"]
    rewrite_shebang python_shebang_rewrite_info(python), *bin.children
    system "make", "-C", "src"
    libexec_src = Pathname.new("#{libexec}/src")
    libexec_src.install "src/long-to-linked-pe"
    btllib_python = formula_opt_lib("btllib")/"btllib/python"
    site_packages = Dir[libexec/"lib/python*/site-packages"].first
    bin.env_script_all_files libexec/"bin",
                             PYTHONPATH: "#{site_packages}#{File::PATH_SEPARATOR}#{btllib_python}"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tigmint --help")
    assert_match "usage", shell_output("#{bin}/tigmint-cut --help")
    assert_match "usage", shell_output("#{bin}/tigmint_molecule.py --help")
    assert_match "usage", shell_output("#{bin}/tigmint_molecule_paf.py --help")
  end
end
