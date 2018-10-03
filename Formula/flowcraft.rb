class Flowcraft < Formula
  desc "Nextflow pipeline assembler for genomics"
  homepage "https://github.com/assemblerflow/flowcraft"
  url "https://github.com/assemblerflow/flowcraft/archive/1.3.1.tar.gz"
  sha256 "77d5289bd5fcbf05917b36764bb1ed5544d54f32c386270f230b5c6e8bc48bb7"
  revision 1
  head "https://github.com/assemblerflow/flowcraft.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "16beda469f347ce5f878638b3332d299c47645135030deb7324750fe27e9066a" => :sierra_or_later
    sha256 "04f4d3c3b41e5028664b37d190f306c067cd93bc693c24b4087cc94ebd8bfbe8" => :x86_64_linux
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
