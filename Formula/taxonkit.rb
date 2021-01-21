class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.7.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "abe3e6fc5421685013ce37513bbd89f23a465a8cb7e2a4b77792ef912d262d4a"
  else
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.7.0/taxonkit_linux_amd64.tar.gz"
    sha256 "8dffe0a436e2248e18c541d0b128f3140cf25454b2f851cf2e0db32ae783ab07"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8d884f4bbba6e7962b835cf50c4b08d5a7f8262b5ac47a2f774cfae0e4772dd7" => :catalina
    sha256 "22b6a81fd7d5de9d3f59826d886b24d139a24f83aaaaefe8e4b91f54a6928483" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
