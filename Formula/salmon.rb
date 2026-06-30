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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "283e64670d74cb80ed09c53018e68f5c78bd684745042d7e7424be2081083ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "283e64670d74cb80ed09c53018e68f5c78bd684745042d7e7424be2081083ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "283e64670d74cb80ed09c53018e68f5c78bd684745042d7e7424be2081083ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494a9d91223aad7fc4f963b33fe3614e304d45d83150462b35e113c0f0fc9441"
  end

  # salmon 2.0 is a from-scratch Rust rewrite shipped as a single binary via
  # cargo-dist (the final C++ release, 1.10.x, lives on the upstream `cpp`
  # branch). Use the prebuilt per-platform artifacts directly.
  #
  # The artifact filenames (salmon-cli-<target-triple>.tar.xz) carry no version,
  # and the `x86_64` triple makes Homebrew mis-scan the version as
  # "64-unknown-linux-gnu". The `#/salmon.tar.xz` fragment renames the download
  # so the scanner ignores the triple and picks up "2.2.1" from the URL path on
  # every platform, keeping detection consistent without a redundant `version`.
  on_macos do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.2.1/salmon-cli-aarch64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "e5cbcaf015c30471e9672ea9545f3dd33b8842bbb21dd07d5b096fa245b23972"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.2.1/salmon-cli-x86_64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "6382d5ef7827d60c5f57b4133804a11030b204f39630346a380cfd3db5b05b1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.2.1/salmon-cli-aarch64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "bb3b7d1f367f1d3a5001b15c83f38d39584ac6451c2b46e779c311f8f48307fb"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.2.1/salmon-cli-x86_64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "a5250dc9d9e9c4f54e24683f787fca59bafb11ba3d46c500ca5f97b3272693e9"
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
