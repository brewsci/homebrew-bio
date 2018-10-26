class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.3.1.tar.gz"
  sha256 "77d5289bd5fcbf05917b36764bb1ed5544d54f32c386270f230b5c6e8bc48bb7"
  revision 1
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
