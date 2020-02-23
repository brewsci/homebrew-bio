class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.2.21.zip"
  sha256 "2477152c8f48fc49fd889085b2568261ad797646266e77334d0d4cd4588ae6dd"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c0e317eb258d153575e9ccfd5a765188b8b7694ae934dd4644f4de1053ca794e" => :catalina
    sha256 "0c770407cb9eca2e1ec7bb9adf06a5e95c94bee5d3f356115a2e824c99b278c5" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install %w[kma kma_index kma_shm]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kma -v 2>&1")
  end
end
