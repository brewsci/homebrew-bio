class Ntlink < Formula
  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/releases/download/v1.2.1/ntLink-1.2.1.tar.gz"
  sha256 "a57e7a30f89ac4d364032b777d71346c850ca5719e471d5b2de5a91d424cc19a"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "fb0bcfbd83bde98d3f5fb4f8f770694a8571dbba7f99c16fa40c7c3767400c09"
    sha256                               x86_64_linux: "e46685a82eba43812a8b6e79b175466f0da1dceea8d9eec7476ed3c92cfc766f"
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
    inreplace "bin/ntlink_overlap_sequences.py", "/usr/bin/env python3", Formula["python@3.10"].bin/"python3.10"
    inreplace "bin/ntlink_filter_sequences.py", "/usr/bin/env python3", Formula["python@3.10"].bin/"python3.10"
    inreplace "bin/ntlink_patch_gaps.py", "/usr/bin/env python3", Formula["python@3.10"].bin/"python3.10"
    inreplace "ntLink", "PYTHONPATH=$(ntlink_path)/src/btllib/install/lib/btllib/python",
    "PYTHONPATH_ntlink=$(ntlink_path)/src/btllib/install/lib/btllib/python:$(PYTHONPATH)"
    inreplace "ntLink", "PYTHONPATH=$(PYTHONPATH)", "PYTHONPATH=$(PYTHONPATH_ntlink)"
    if OS.linux?
      system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt", "--no-binary=:all:"
    else
      system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    end
    bin.install "ntLink"
    libexec_src = Pathname.new("#{libexec}/src")
    libexec_src.install "src/indexlr"
    libexec_src.install "src/btllib"
    libexec_bin = Pathname.new("#{libexec}/bin")
    libexec_bin.install Dir["bin/*"]
    bin.env_script_all_files libexec, PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
    rm_rf "#{libexec}/src/btllib/subprojects/sdsl-lite/Make.helper"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntLink help")
  end
end
