class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.2.8.zip"
  sha256 "67d12eda3955c860355421685c13b4b705314b5085868a71f169d2b615f03c08"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "cbfefe7546a5df7b5b2ed5414be613152beb8bcf7e97524f64f2ca01aff5b90f" => :sierra
    sha256 "e54d17008120a044e39eed76089655af8a8187407fad6ae1db2b29f4d3c581c5" => :x86_64_linux
  end

  def install
    system "make"
    bin.install %w[kma kma_index kma_shm]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kma -v 2>&1")
  end
end
