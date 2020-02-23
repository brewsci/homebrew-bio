class FinchRs < Formula
  # Bovee_2018: "https://doi.org/10.21105/joss.00505"
  desc "Genomic minhashing implementation in Rust"
  homepage "https://github.com/onecodex/finch-rs"
  if OS.mac?
    url "https://github.com/onecodex/finch-rs/releases/download/v0.3.0/finch-mac64-v0.3.0.zip"
    sha256 "06535290f528901868f566beadce71ae89d3b3e238b805317318e6109f756fe0"
  else
    url "https://github.com/onecodex/finch-rs/releases/download/v0.3.0/finch-linux64-v0.3.0.gz"
    sha256 "d6c41f123bfa4d58028cd2ef9d9981cdd3ed5568f02f53c34e8be602224f7f1b"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "eca9f68be258523651b801b889a7535638b069ffe06d5608dc6171da192aacc3" => :catalina
    sha256 "b9e2bc391659d9e97baec72828d5c5d90ec5c991a3a6a0d80f17ec2b52732240" => :x86_64_linux
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
