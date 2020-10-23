class Xmatchview < Formula
  # cite L_Warren_2018: "https://doi.org/10.21105/joss.00497"
  desc "Smith-waterman alignment visualization"
  homepage "https://github.com/bcgsc/xmatchview"
  url "https://github.com/bcgsc/xmatchview/archive/v1.2.5.tar.gz"
  sha256 "c262440b100e46b362306afd07da59b79fa7b5e38d2f898550fd87b338aec819"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/xmatchview.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "3f69176e6aee0b04a146b13eecc2f4744a6735d18279638fc3e237b4c1369960" => :catalina
    sha256 "13c6109f7a538b4278a468af00ea362ad4d2427ad5e1b9b927f1cfa0b979b985" => :x86_64_linux
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
    prefix.env_script_all_files libexec/"bin", PYTHONPATH: Dir[libexec/"lib/python*/site-packages"].first
    bin.install_symlink "../xmatchview.py", "../xmatchview-conifer.py"
    chmod 0555, Dir[prefix/"xmatchview*py"]
    prefix.install "test"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/xmatchview.py", 1)
    assert_match "Usage", shell_output("#{bin}/xmatchview-conifer.py", 1)
  end
end
