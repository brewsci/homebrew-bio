class Anvio < Formula
  # cite Eren_2015: "https://doi.org/10.7717/peerj.1319"
  desc "Analysis and visualization platform for ‘omics data"
  homepage "http://merenlab.org/software/anvio/"
  url "https://github.com/merenlab/anvio/archive/v5.3.tar.gz"
  sha256 "890f72a5878e24683ee8a27071853c69f5e63d7c4b3d0c8e31e3490f9189654e"
  head "https://github.com/merenlab/anvio.git"

  depends_on "cython" => :build
  depends_on "matplotlib"
  depends_on "numpy"
  depends_on "python"
  depends_on "scipy"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # datrie 0.7.1 fails to install with Python 3.7. See https://github.com/pytries/datrie/issues/52
    system "pip3", "install", "--prefix=#{libexec}", "git+https://github.com/pytries/datrie.git"
    system "pip3", "install", "--prefix=#{libexec}", "."

    Dir[libexec/"bin/*"].each do |executable|
      next unless File.file?(executable) && File.executable?(executable)
      inreplace executable, "#!/usr/bin/env python", Formula["python"].bin/"python3", false
      name = File.basename executable
      (bin/name).write_env_script executable, :PYTHONPATH => ENV["PYTHONPATH"]
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/anvi-profile --help")
  end
end
