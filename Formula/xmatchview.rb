class Xmatchview < Formula
  # cite L_Warren_2018: "https://doi.org/10.21105/joss.00497"
  desc "Smith-waterman alignment visualization"
  homepage "https://github.com/bcgsc/xmatchview"
  url "https://github.com/bcgsc/xmatchview/archive/v1.2.3.tar.gz"
  sha256 "774dd0f07946511b853eed167d3fbff56f72fa0ee0f4a586207904246789042e"
  head "https://github.com/bcgsc/xmatchview.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2b17c832197c0abd912495ca38cfbd2963218e8771be3efbfad7d3c51b2da504" => :sierra
    sha256 "280d250cd2daefca86d6c2fe5fa64033b3a7dd68b548563d8ca6fae76d14c681" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "python"

  uses_from_macos "zlib"

  def install
    # Fix the error: The headers or library files could not be found for zlib,
    # a required dependency when compiling Pillow from source.
    ENV["CPATH"] = "#{MacOS.sdk_path}/usr/include" if MacOS.sdk_path_if_needed

    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip3", "install", "--no-cache-dir", "--prefix=#{libexec}", "pillow", "--no-binary=pillow"
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
