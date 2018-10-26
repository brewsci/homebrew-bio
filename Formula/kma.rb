class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/77d2d3999493.zip"
  version "0.14.3"
  sha256 "89f67ad0edd270dcc4249c37567eef1acc4ba94b450791c5ace34e1425866caa"

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
