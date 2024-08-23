class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.4.15.zip"
  sha256 "7510ae387fbfa399aea66cf7ed9ae849f7235266fb967d4c33d6c2a0c24c168a"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "e8986aca613c9b2c302cf25484d17d1e7f1dfef0d395d9b142f52cda3171fffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95351af4a7d8e9ece5040641c8c53a4e28938f73e966dbd1670743ea1c677c82"
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
