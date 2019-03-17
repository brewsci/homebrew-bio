class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.4.1.tar.gz"
  sha256 "ca5f698f286b6bcc6fc15cb7767ae903e06f6b7af11183917845b1be4304f11f"
  head "https://github.com/assemblerflow/flowcraft.git", :branch => "dev"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "f6a37ba5294eb518772ff4d2d325fcfbbe9c37cd009d1c135e015ce247f2edc6" => :sierra
    sha256 "3d7729b04a2586ac131dab82578b432a2f1601680bdad2eca9bb4fa899c3e586" => :x86_64_linux
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
