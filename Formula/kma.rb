class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.6.13.zip"
  sha256 "dee19afa76170c8afeafa688fe5deb49a9b044841cdc67dde65b3ed01a6b7186"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda51b5d2c48f22190d469b129e3f1a5efe86e7fc764a48cc8544267f917b24c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16fa6d04392fd9deadcb1d6c2ca6cba608802c4cf1d9a4e8a92778aaa7a6622a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85eb4534a9d224bbabc1918424e3f2795c3bf4b81dd6d99a51a71a814fd470a1"
    sha256 cellar: :any,                 x86_64_linux:  "c17f6a707b326f4808672957b1ef0caad7aa675986e8e3586ce071f84b3f0d77"
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
