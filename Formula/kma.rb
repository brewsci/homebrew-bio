class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.3.3.zip"
  sha256 "18fcd36c597dc4697607a330665566ae6fe6cb911bfc5d3a895cf39095bae6a6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1ac1b89fc3e971452dbab07c2853f5bb0a9f54a8e3aa7e93b8b4bf4bb639c582" => :catalina
    sha256 "f547bbac1954b231161e8d5f4d65f70058f1fe6e7620e1b3889b4e1427f8caa9" => :x86_64_linux
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
