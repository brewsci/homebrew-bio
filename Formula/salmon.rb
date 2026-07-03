class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  license "BSD-3-Clause"

  # Track GitHub releases so new versions are detected by `brew livecheck`.
  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f9ba4fb85285f1fb458612e6dce361a9368fb585b7bceedf5c2b0a7799d7782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f9ba4fb85285f1fb458612e6dce361a9368fb585b7bceedf5c2b0a7799d7782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f9ba4fb85285f1fb458612e6dce361a9368fb585b7bceedf5c2b0a7799d7782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb7cb9dfd4558297b6849c7c4f5a412818ee19e9d6f81ec7ecc76805b6899b1"
  end

  # salmon 2.0 is a from-scratch Rust rewrite shipped as a single binary via
  # cargo-dist (the final C++ release, 1.10.x, lives on the upstream `cpp`
  # branch). Use the prebuilt per-platform artifacts directly.
  #
  # The artifact filenames (salmon-cli-<target-triple>.tar.xz) carry no version,
  # and the `x86_64` triple makes Homebrew mis-scan the version as
  # "64-unknown-linux-gnu". The `#/salmon.tar.xz` fragment renames the download
  # so the scanner ignores the triple and picks up "2.3.0" from the URL path on
  # every platform, keeping detection consistent without a redundant `version`.
  on_macos do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.0/salmon-cli-aarch64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "adff8afed7404254db4389a0ba2c3f7ccbbc5775bc75c1e72a1a41099444bc9c"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.0/salmon-cli-x86_64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "9d7016acd38f754e774f6d6481d29863ae6ac39889b41e995dbd1e1ef3e4ade4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.0/salmon-cli-aarch64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "5fe21d0a1d3ef14b58b49b12fa205ef61c530dd2eceb897458ddf6cc7b49130f"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.0/salmon-cli-x86_64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "0816c1764e580db4a2a2b7854f6b784fbe8d498539139a94ef6549f5304d43f1"
    end
  end

  def install
    bin.install "salmon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version")

    # Build a tiny index end to end.
    (testpath/"txome.fa").write ">t0\n#{"ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT" * 4}\n"
    system bin/"salmon", "index", "-t", "txome.fa", "-i", "idx", "-k", "31"
    assert_predicate testpath/"idx", :directory?
  end
end
