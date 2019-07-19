class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.4.1.tar.gz"
  sha256 "ca5f698f286b6bcc6fc15cb7767ae903e06f6b7af11183917845b1be4304f11f"
  revision 1
  head "https://github.com/assemblerflow/flowcraft.git", :branch => "dev"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2a803d712d230c37fdd9d002184c0b5358040419dc1db0c1bcf144fc5b6b738b" => :sierra
    sha256 "81bb9ded1248cc2e277ebb3d88e100a956167f4a8f79d9018a4f2257bfdc1244" => :x86_64_linux
  end

  depends_on "nextflow"
  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", "setup.py", "install", "--prefix=#{libexec}"
    (bin/"flowcraft").write_env_script libexec/"bin/flowcraft", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/flowcraft --help")
  end
end
