class Ntlink < Formula
  # cite Coombe_2021: "https://doi.org/10.1101/2021.06.17.448848"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/releases/download/v1.1.0/ntLink-1.1.0.tar.gz"
  sha256 "836b70e13cd0ba07d24698b350a666f23e2ae921af04868b61b548c6e0a8ea01"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "4ea6168c077875deedbc254c27b7dcf271504a4112aa777f3b020b9c5fe5f044"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01d149c1fc8809b02c3ddc5f47a1fec36869bffaa2db2e239a7015a60a060adf"
  end

  depends_on "abyss"
  depends_on "numpy"
  depends_on "python@3.8"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "make", "-C", "src"
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "requirements.txt", "python-igraph", "python-igraph==0.7.1.post6"
    inreplace "bin/ntlink_pair.py", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    inreplace "bin/ntlink_stitch_paths.py", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install "ntLink"
    libexec_src = Pathname.new("#{libexec}/src")
    libexec_src.install "src/indexlr"
    libexec_bin = Pathname.new("#{libexec}/bin")
    libexec_bin.install Dir["bin/*"]
    bin.env_script_all_files libexec, PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntLink help")
  end
end
