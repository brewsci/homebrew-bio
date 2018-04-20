class FinchRs < Formula
  desc "Genomic minhashing implementation in Rust"
  homepage "https://github.com/onecodex/finch-rs"
  if OS.mac?
    url "https://github.com/onecodex/finch-rs/releases/download/v0.1.5/finch-mac64-v0.1.5.zip"
    sha256 "0638b92a11f243d410f8d72c727d31c23f9b01e441b47971080e80caeb706ae4"
  else
    url "https://github.com/onecodex/finch-rs/releases/download/v0.1.5/finch-linux64-v0.1.5.tar.gz"
    sha256 "f513602d6851fa865878e6ca402903b9f5b14f65f12017b3d300fc4b64e6855a"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0fe81384891552713f78ca597a56ece5495b6ba1957f4462367d25dc81e4062f" => :sierra_or_later
    sha256 "04c19cd85384188617657ed68f18e1a4e43123be4a5b1d1e555699d956de4c97" => :x86_64_linux
  end


  depends_on "patchelf" => :build unless OS.mac?

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
