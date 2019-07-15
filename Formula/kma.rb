class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.2.8.zip"
  sha256 "67d12eda3955c860355421685c13b4b705314b5085868a71f169d2b615f03c08"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "52522844f305d67dc389fa3c3034227d2a72ffa6ce66bba2b7498db214af0b30" => :sierra
    sha256 "ac88a5f2440997f0f09d08f4f734cf9d8f129a10d91c98661a9108ceaaecac08" => :x86_64_linux
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
