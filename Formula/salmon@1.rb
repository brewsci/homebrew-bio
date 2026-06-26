class SalmonAT1 < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads (C++ 1.x line)"
  homepage "https://github.com/COMBINE-lab/salmon"
  license "GPL-3.0-or-later"

  # salmon 2.0 is a Rust rewrite shipped as the unversioned `salmon` formula.
  # This keeps the final C++ release (1.x line) available alongside it via the
  # upstream prebuilt binaries. Both provide a `salmon` binary, so stay
  # keg-only to avoid a link conflict.
  #
  # The release filenames (salmon-<os>-<arch>.tar.gz) carry no version, so the
  # `#/salmon.tar.gz` fragment renames the download and lets Homebrew read
  # "1.12.1" from the URL path consistently on every platform.
  keg_only :versioned_formula

  on_macos do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v1.12.1/salmon-macos-arm64.tar.gz#/salmon.tar.gz"
      sha256 "66a711fc594f0cfe3310885b7c3b94820b51ecef8fbfbf3598fad38f5be51831"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v1.12.1/salmon-macos-x86_64.tar.gz#/salmon.tar.gz"
      sha256 "b40dcd0686ffe9f93cbf2105dcfbe4a4db6819971b420d257ea47f25be9a26e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v1.12.1/salmon-linux-aarch64.tar.gz#/salmon.tar.gz"
      sha256 "fccee6d68d72ad3f5afdc2d9c54b84c5b66b175005e9a97763d75d25722a3017"
    end
    on_intel do
      url "https://github.com/COMBINE-lab/salmon/releases/download/v1.12.1/salmon-linux-x86_64.tar.gz#/salmon.tar.gz"
      sha256 "00900135ecca10b45e3d78a6ab64463f957d0b2b0069eaa078c10784f1e2f8d6"
    end
  end

  def install
    bin.install "bin/salmon"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
