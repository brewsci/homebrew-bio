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
    cellar :any_skip_relocation
    sha256 "0fe81384891552713f78ca597a56ece5495b6ba1957f4462367d25dc81e4062f" => :sierra_or_later
    sha256 "04c19cd85384188617657ed68f18e1a4e43123be4a5b1d1e555699d956de4c97" => :x86_64_linux
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
