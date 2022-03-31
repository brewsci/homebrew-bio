class Ntlink < Formula
  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/releases/download/v1.1.3/ntLink-1.1.3.tar.gz"
  sha256 "bcc24d6a2eadad773eec5dca14d29f4ff5b9d71f28ae12cb4b1e12c9132b9c7e"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2e97ff753565662836319678e8d9928d765bd779f7382241d9f5324d3339006a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "200cf5be27375ee7855d0c788925e06e53e83376dd039584aa46bed32ecf4c14"
  end

  depends_on "cmake" => :build
  depends_on "gcc@11" => :build if OS.linux?
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "abyss"
  depends_on "igraph"
  depends_on "numpy"
  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  fails_with gcc: "5" if OS.linux?

  def install
    system "make", "-C", "src"
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "bin/ntlink_pair.py", "/usr/bin/env python3", Formula["python@3.10"].bin/"python3.10"
    inreplace "bin/ntlink_stitch_paths.py", "/usr/bin/env python3", Formula["python@3.10"].bin/"python3.10"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt", "--no-binary=:all:"
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
