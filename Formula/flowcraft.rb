class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.4.0.tar.gz"
  sha256 "cbcaa7d0a89b29ad2e650d1d4cb028de5a2795b5452a640d5c8f320c367c0048"
  head "https://github.com/assemblerflow/flowcraft.git", :branch => "dev"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "93df18d0197e3be13f4bc811076a332ff4d6f8c211827bf629a46227ee7abc0c" => :sierra
    sha256 "6ddcf08639562b304cb1780a9a0249accb826bcea7807d7c38fc607af438a0cf" => :x86_64_linux
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
