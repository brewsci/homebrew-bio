class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1101/304253"
  desc "Correct misassemblies using linked reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/archive/1.1.1.tar.gz"
  sha256 "6e67224ec00c266228e92d0266ea80141dfee23980ed93a05156aa9bf2134406"
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "36bd557f6c41fa5034e1b0305553825bd0df26bf5306317f0f5197ed0536d5b8" => :sierra_or_later
    sha256 "580262b97b0695b1ab187d1999b72af2c16cb08a8b72b0ce3b92d6e60d8254ac" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "python"

  def install
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => Dir[libexec/"lib/python*/site-packages"].first
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tigmint --help")
    assert_match "usage", shell_output("#{bin}/tigmint-cut --help")
    assert_match "usage", shell_output("#{bin}/tigmint-molecule --help")
  end
end
