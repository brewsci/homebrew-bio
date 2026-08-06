class Unikmer < Formula
  desc "Manipulate small kmers without frequency information"
  homepage "https://github.com/shenwei356/unikmer"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8a29877ed01403b14e60320e073b05012a260f91e258d9f4290239a133a5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb8a29877ed01403b14e60320e073b05012a260f91e258d9f4290239a133a5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8a29877ed01403b14e60320e073b05012a260f91e258d9f4290239a133a5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef436c716b5ac7adf96cd7ca9dda14192b5300316d57c1e3c1df5f7d7f0fe0cd"
  end

  on_macos do
    on_arm do
      url "https://github.com/shenwei356/unikmer/releases/download/v0.20.0/unikmer_darwin_arm64.tar.gz"
      sha256 "0d895b85c9dd5cd3c8620426a53679bc58714b291cdb7b298b781722d2b674fa"
    end
    on_intel do
      url "https://github.com/shenwei356/unikmer/releases/download/v0.20.0/unikmer_darwin_amd64.tar.gz"
      sha256 "e065348a1cb123c720666f20cadd306b72990891d12583bfe4c43a07625e22f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shenwei356/unikmer/releases/download/v0.20.0/unikmer_linux_arm64.tar.gz"
      sha256 "aa08583ea58f8b29398df195055cd9b5374e08b317e4c10427f678d5055525e8"
    end
    on_intel do
      url "https://github.com/shenwei356/unikmer/releases/download/v0.20.0/unikmer_linux_amd64.tar.gz"
      sha256 "f6558c7f01c6c3458e52ada9a0fde276f4d4b1a32458f0fdc80760d39928022d"
    end
  end

  def install
    bin.install "unikmer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unikmer --help 2>&1")
  end
end
