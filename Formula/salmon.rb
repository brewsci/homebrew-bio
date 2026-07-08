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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e177735add1b2f352e18e988f9c1290f5a728ee7ba05b63af9f44ed7da779bb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e177735add1b2f352e18e988f9c1290f5a728ee7ba05b63af9f44ed7da779bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e177735add1b2f352e18e988f9c1290f5a728ee7ba05b63af9f44ed7da779bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81874085a0858e4990c2f63c02af88660e0fbd9aa6000cd7b6a6cd0317225df"
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
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.1/salmon-cli-aarch64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "203c0659af46a27396354ba3c5de844074d5c06af73923e97cbc73a02eed547f"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.1/salmon-cli-x86_64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "cd95e213325cbe17b425e7c0b11d05d2960a304698dd00771eba50592840c14c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.1/salmon-cli-aarch64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "478377823b9eb74c8ad8f1d2df68ff85bc1fc018c1f7f40296f80c64e4cb4acc"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.3.1/salmon-cli-x86_64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "0b5390db80ac2ccfe963e24c201e6bcffafe82807054f28f47cafa9c84e868ef"
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
