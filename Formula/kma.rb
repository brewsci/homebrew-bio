class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.3.6.zip"
  sha256 "b672b72103bc38977060c8e3f7f158bb7f06ffdc8eabfc4aa72985c250b57c26"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e8986aca613c9b2c302cf25484d17d1e7f1dfef0d395d9b142f52cda3171fffc" => :catalina
    sha256 "95351af4a7d8e9ece5040641c8c53a4e28938f73e966dbd1670743ea1c677c82" => :x86_64_linux
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
