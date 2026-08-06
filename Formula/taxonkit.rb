class Taxonkit < Formula
  desc "NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7472f1649dbec3d8740947469230638410ec6bbb16d2c01e6d9c07dd7f54110c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7472f1649dbec3d8740947469230638410ec6bbb16d2c01e6d9c07dd7f54110c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7472f1649dbec3d8740947469230638410ec6bbb16d2c01e6d9c07dd7f54110c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca76acbad5720d369da551cb1d3626d75602a3b4280afe6be778705ad2e8568"
  end

  on_macos do
    on_arm do
      url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_darwin_arm64.tar.gz"
      sha256 "0213894b172fa2a84c65851a64dfa04b4cbcd3f8265549c088d3dc46777cc461"
    end
    on_intel do
      url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_darwin_amd64.tar.gz"
      sha256 "9afd16c472b1337cf7651f37cbc9fd1e94861169999872163bafabf166171960"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_linux_arm64.tar.gz"
      sha256 "f7a8c0d6ef7371210b769b42f0a5b5dcfa409753670bfa1c5028d78375745c66"
    end
    on_intel do
      url "https://github.com/shenwei356/taxonkit/releases/download/v0.20.0/taxonkit_linux_amd64.tar.gz"
      sha256 "d801ea82f9e516a9f0ccecf72a8212809677b8742fb9528d407fbfca8811a553"
    end
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
