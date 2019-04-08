class Xmatchview < Formula
  # cite L_Warren_2018: "https://doi.org/10.21105/joss.00497"
  desc "Smith-waterman alignment visualization"
  homepage "https://github.com/bcgsc/xmatchview"
  url "https://github.com/bcgsc/xmatchview/archive/v1.1.1.tar.gz"
  sha256 "987ee64c9287c89bf4eba1c4f2438bf7a49ae70fab34c0282e724710d56d75cc"
  head "https://github.com/bcgsc/xmatchview.git"

  depends_on "jpeg"
  depends_on "python@2"
  depends_on "zlib" unless OS.mac?

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python2"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip", "install", "--prefix=#{libexec}", "pillow", "--no-binary=pillow"
    inreplace "xmatchview.py", "#!/usr/bin/python", "#!/usr/bin/env python"
    inreplace "xmatchview-conifer.py", "#!/usr/bin/python", "#!/usr/bin/env python"
    prefix.install Dir["xmatchview*py"]
    prefix.env_script_all_files libexec/"bin", :PYTHONPATH => Dir[libexec/"lib/python*/site-packages"].first
    bin.install_symlink "../xmatchview.py", "../xmatchview-conifer.py"
    chmod 0555, Dir[prefix/"xmatchview*py"]
    prefix.install "test"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/xmatchview.py", 1)
    assert_match "Usage", shell_output("#{bin}/xmatchview-conifer.py", 1)
  end
end
