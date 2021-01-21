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
    sha256 "1003d7128892ceb220db276f3ff63f39df885282c297aaba0661150f4896b6a8" => :catalina
    sha256 "08741bc649f65882a787119ca61eb53db8ad6da4ad8a03e86664e1ce6d62af65" => :x86_64_linux
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
