class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.4.1.tar.gz"
  sha256 "ca5f698f286b6bcc6fc15cb7767ae903e06f6b7af11183917845b1be4304f11f"
  license "GPL-3.0"
  revision 2
  head "https://github.com/assemblerflow/flowcraft.git", branch: "dev"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b00d9a38dba24638665dfb23815b381ec7b4b41ab82d3b132483aa82b29ae4aa" => :catalina
    sha256 "45938c7344382686e14ef63d568e1ef74ad9155285cf9fe584127bb837484c4e" => :x86_64_linux
  end

  depends_on "brewsci/bio/nextflow"
  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip3", "install", "--prefix=#{libexec}", "."
    (bin/"flowcraft").write_env_script libexec/"bin/flowcraft", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/flowcraft --help")
  end
end
