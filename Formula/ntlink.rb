class Ntlink < Formula
  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/releases/download/v1.1.2/ntLink-1.1.2.tar.gz"
  sha256 "bf0358887aa2b7a96a27ad86e69fd3093551e5266760f311cb953587b6fbf681"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "0260c68ec2ec550a1bbe770ea3c505067e266241171d937e145a893a367888c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74f5bbb66962275929ff73e8a9a4cd29e56433b3eb51f113f8f00cf22c22ecb5"
  end

  depends_on "cmake" => :build
  depends_on "abyss"
  depends_on "igraph"
  depends_on "numpy"
  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    system "make", "-C", "src"
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "bin/ntlink_pair.py", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    inreplace "bin/ntlink_stitch_paths.py", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
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
