class Xmatchview < Formula
  # cite L_Warren_2018: "https://doi.org/10.21105/joss.00497"
  desc "Smith-waterman alignment visualization"
  homepage "https://github.com/bcgsc/xmatchview"
  url "https://github.com/bcgsc/xmatchview/archive/v1.2.0.tar.gz"
  sha256 "17723ba8d6162c2b57f9c63f1f93fcc878963eb00097a12a575c8b3b3c9ef1bf"
  head "https://github.com/bcgsc/xmatchview.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2b17c832197c0abd912495ca38cfbd2963218e8771be3efbfad7d3c51b2da504" => :sierra
    sha256 "280d250cd2daefca86d6c2fe5fa64033b3a7dd68b548563d8ca6fae76d14c681" => :x86_64_linux
  end

  depends_on "jpeg"

  # uses_from_macos "python@2"
  uses_from_macos "zlib"

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
