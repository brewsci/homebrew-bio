class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.4.15.zip"
  sha256 "7510ae387fbfa399aea66cf7ed9ae849f7235266fb967d4c33d6c2a0c24c168a"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "1803cdd3e950817947b43c10c24bc4932833df288623838e2833621f5ccb2a81"
    sha256 cellar: :any_skip_relocation, ventura:      "800401e4775a5891720bf9272fc984376ca7e689abad36c07bd5b16fee150eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae07d03f57f0e964ee8c0a420f7f6ff9de7045bafb9c33dda2743cb5ab40cedd"
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
