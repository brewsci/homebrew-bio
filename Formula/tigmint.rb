class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/archive/1.2.1.tar.gz"
  sha256 "d0220f2b5b9e8c7ec4f34efb223e04954fe3d741d099a92f7ed0c59c831b8420"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9a292eab8ee0a550a48441c4eb873682a4109b59c412a058bd37c3e6f898fc33" => :sierra
    sha256 "c115d2d29ba6216fa4a3a858510ff17a8b57efc96c427e9b66d98fc3c29e00e0" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "minimap2"
  depends_on "python@3.8"

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "bin/tigmint-cut", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    inreplace "bin/tigmint-molecule", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    inreplace "bin/long-to-linked", "/usr/bin/env python3", Formula["python@3.8"].bin/"python3.8"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tigmint --help")
    assert_match "usage", shell_output("#{bin}/tigmint-cut --help")
    assert_match "usage", shell_output("#{bin}/tigmint-molecule --help")
    assert_match "usage", shell_output("#{bin}/long-to-linked --help")
  end
end
