class Ngmaster < Formula
  desc "NG-MAST genotyping for Neisseria gonorrhoeae"
  homepage "https://github.com/MDU-PHL/ngmaster"
  url "https://github.com/MDU-PHL/ngmaster/archive/v0.5.6.tar.gz"
  sha256 "908b8504804026554a0ec357933b773f6f47b98a0ce5fff77894e743d34200bc"
  license "GPL-2.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "dc8748c713ff3337044763bef882f037a5586b01fe7affc1dec7524b52a5def4" => :catalina
    sha256 "5744a66095f4317395ccdbe243f00b06e25e16d1840c89b03cd4793f29e7a27c" => :x86_64_linux
  end

  depends_on "ispcr"
  depends_on "numpy"
  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{libexec}"
    (bin/"ngmaster").write_env_script libexec/"bin/ngmaster", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngmaster --version 2>&1")
    system "#{bin}/ngmaster", "--test"
  end
end
