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
