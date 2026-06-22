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
  # so the scanner ignores the triple and picks up "2.1.1" from the URL path on
  # every platform, keeping detection consistent without a redundant `version`.
  on_macos do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.1/salmon-cli-aarch64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "b83e8ab05762437c05f220796f14aff7aa65993cfd63c9b6705db2700f69f311"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.1/salmon-cli-x86_64-apple-darwin.tar.xz#/salmon.tar.xz"
      sha256 "4d28b786482caeab7f19ba976bba8ae13cc7268e4a2adc0919d9cf758113fb43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.1/salmon-cli-aarch64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "dea1432725e8530f90c75c0bcbbb8d7e88d145af23862aeecbbaa98bdb5f89fe"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v2.1.1/salmon-cli-x86_64-unknown-linux-gnu.tar.xz#/salmon.tar.xz"
      sha256 "184d87c5f376b33074e5d5a26538201d3ab13a9c7ea57c7862359b0c0d678d0e"
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
