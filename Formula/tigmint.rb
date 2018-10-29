class Tigmint < Formula
  # cite Jackman_2018: "https://doi.org/10.1186/s12859-018-2425-6"
  desc "Correct misassemblies using linked reads"
  homepage "https://bcgsc.github.io/tigmint/"
  url "https://github.com/bcgsc/tigmint/archive/1.1.2.tar.gz"
  sha256 "1cff0c5087f9f8f9cf0f129539585e1e5ae7288922b5f5f4ff36f2d936846783"
  revision 2
  head "https://github.com/bcgsc/tigmint.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "9a292eab8ee0a550a48441c4eb873682a4109b59c412a058bd37c3e6f898fc33" => :sierra
    sha256 "c115d2d29ba6216fa4a3a858510ff17a8b57efc96c427e9b66d98fc3c29e00e0" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "python"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
    sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
  end

  def install
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    resource("cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    system "pip3", "install", "--prefix=#{libexec}",
      "git+https://github.com/pysam-developers/pysam.git",
      "git+https://github.com/daler/pybedtools.git"
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
