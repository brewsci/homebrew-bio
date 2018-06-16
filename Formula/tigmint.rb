class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1101/304253"
  desc "Correct misassemblies using linked reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/archive/1.1.2.tar.gz"
  sha256 "1cff0c5087f9f8f9cf0f129539585e1e5ae7288922b5f5f4ff36f2d936846783"
  revision 1
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "f67016f977bef91f20caee3874c400453e1fc059c2f2c7464eef82244af6081a" => :sierra_or_later
    sha256 "0d450428211c6804936317a7a9c62f655d5f22be1707456f076c61a5dba36b7f" => :x86_64_linux
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
