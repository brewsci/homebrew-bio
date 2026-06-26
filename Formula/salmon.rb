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

  # salmon 2.0 is a from-scratch Rust rewrite shipped as a single binary via
  # cargo-dist (the final C++ release, 1.10.x, lives on the upstream `cpp`
  # branch). Use the prebuilt per-platform artifacts directly.
  #
  # The artifact filenames (salmon-cli-<target-triple>.tar.xz) carry no version,
  # and the `x86_64` triple makes Homebrew mis-scan the version as
  # "64-unknown-linux-gnu". The `#/salmon.tar.xz` fragment renames the download
  # so the scanner ignores the triple and picks up "2.1.2" from the URL path on
  # every platform, keeping detection consistent without a redundant `version`.
  on_macos do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.2/salmon-cli-aarch64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "0d8ada4db7ebedbfc189d15ff570773c4a9d4d25a5d4c3e48c34ac47cadf00ab"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.2/salmon-cli-x86_64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "c12cf50bd52a9547b75ba0ffd9749491ddd311a2b5a98d3077ff44dc9120a4c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.2/salmon-cli-aarch64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "2e09b3bbcbb50b74a82166367ce7c1ad7dda39ef7b438fd50d0202d88f885048"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.2/salmon-cli-x86_64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "6ecba19104f76667c62a0211bd4e208dbcfb2d1386bdc6925baea9081cf72124"
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
