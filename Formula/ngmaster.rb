class Ngmaster < Formula
  desc "NG-MAST genotyping for Neisseria gonorrhoeae"
  homepage "https://github.com/MDU-PHL/ngmaster"
  url "https://github.com/MDU-PHL/ngmaster/archive/v0.5.5.tar.gz"
  sha256 "bfd9290dee6d3a2159852b68305b3e886c7f8b382eb9f0fbca7acd6b2d2eb502"

  depends_on "ispcr"
  depends_on "numpy"
  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{libexec}"
    (bin/"ngmaster").write_env_script libexec/"bin/ngmaster", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngmaster --version 2>&1")
    system "#{bin}/ngmaster", "--test"
  end
end
