class FinchRs < Formula
  # Bovee_2018: "https://doi.org/10.21105/joss.00505"
  desc "Genomic minhashing implementation in Rust"
  homepage "https://github.com/onecodex/finch-rs"
  if OS.mac?
    url "https://github.com/onecodex/finch-rs/releases/download/v0.1.8/finch-mac64-v0.1.8.zip"
    sha256 "8e840c9a817b7f8d975a4634a03e7c0a4c9c96c2d9838214015b2c4c9ed7d764"
  else
    url "https://github.com/onecodex/finch-rs/releases/download/v0.1.8/finch-linux64-v0.1.8.gz"
    sha256 "d2c35e65956b02ea1833f2529f139c593c87d26b5d83a2de3d4793d4b3be2154"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "2e897484a427b9a334948ca8a24ee6512f34bc8ae450a717f680072ef935a570" => :sierra
    sha256 "7f7facafdcf630b9d9caec6d8f4b8d302494ccbfc71ff1581b4114f31daa68e7" => :x86_64_linux
  end

  depends_on "patchelf" => :build unless OS.mac?
  depends_on "xz"

  def install
    exe = "finch"
    bin.install exe
    if OS.linux?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/exe
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/finch --version 2>&1")
  end
end
