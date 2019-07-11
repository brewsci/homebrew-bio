class FinchRs < Formula
  # Bovee_2018: "https://doi.org/10.21105/joss.00505"
  desc "Genomic minhashing implementation in Rust"
  homepage "https://github.com/onecodex/finch-rs"
  if OS.mac?
    url "https://github.com/onecodex/finch-rs/releases/download/v0.2.0/finch-mac64-v0.2.0.zip"
    sha256 "327d452d33e459afb8a32068354af133fd51bc636c7940a7cf53e5c87f12ce9f"
  else
    url "https://github.com/onecodex/finch-rs/releases/download/v0.2.0/finch-linux64-v0.2.0.gz"
    sha256 "eda928092dda714732a956e647fb8bdcc60d12bd958db55db075b4748cc3eaab"
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "70247045d1517084a4297c42f2c2f8c7cbfdfb4999c434ff796318e0987a65a2" => :sierra
    sha256 "47491278c899f82d8691d528a75a0934f2db112008e4bdae5103b534081e7bf2" => :x86_64_linux
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
