class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked or long reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/releases/download/1.2.2/tigmint-1.2.2.tar.gz"
  sha256 "89c03d9b44ffca37f32aee7179b79b74e4f89feba935af74bf6d1b8ff1e17f54"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1f919b447553c75b731b405a70a5b0973995c1add24fb41ab5ceca8e1ea3d5f0" => :catalina
    sha256 "3970ada8c1db11a0c98358bcc9887593afa52f8a97343807e34d4a91790f5cd0" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "minimap2"
  depends_on "numpy"
  depends_on "python@3.9"

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "bin/tigmint-cut", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    inreplace "bin/tigmint-molecule", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
    inreplace "bin/long-to-linked", "/usr/bin/env python3", Formula["python@3.9"].bin/"python3.9"
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
