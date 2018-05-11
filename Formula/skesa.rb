class Skesa < Formula
  desc "Strategic Kmer Extension for Scrupulous Assemblies"
  homepage "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/"
  url "https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/skesa.centos6.9"
  version "2.2"
  sha256 "26158881c6895529924147877d627fc2c702f4c83ace0b93e279b9d6144b9fc7"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "9ecfd501164b0e6f4f33b0b2363134846c9d4b484e56fe985ad249db8716e3b8" => :x86_64_linux
  end

  depends_on :linux

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "zlib"
  end

  def install
    bin.install Dir["skes*"].first => "skesa"
    unless OS.mac?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/"skesa"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skesa --version 2>&1")
  end
end
