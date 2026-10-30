class Bonsai < Formula
  desc "Ultrafast, flexible taxonomic analysis and classification"
  homepage "https://github.com/dnbaker/bonsai"
  url "https://github.com/dnbaker/bonsai/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "250a22eb000918f33d6e1cdd5b3e58d144605e5bf8a3da757c43445a6d795dda"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "189b70f92aa7b714bc645f5ab759646e0871181a8a6b463dfd3fe11b989fc300"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13dd340ff0ff41c70d77d01e9e9e54a90783d98409492428861fbfea31f02762"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "zlib"
  end

  def install
    arch = OS.mac? ? "osx" : "linux64"
    bin.install Dir["release/#{arch}/*"]
    if OS.mac?
      bin.install_symlink bin/"bonsai_s" => "bonsai"
      bin.install_symlink bin/"bonsai_sz" => "bonsai_z"
    else
      Dir["#{bin}/*"].each do |exe|
        system "patchelf",
               "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
               "--set-rpath", HOMEBREW_PREFIX/"lib",
               exe
      end
    end
    pkgshare.install "ref", "python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bonsai --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/bonsai_z --version 2>&1")
    assert_match "threads", shell_output("#{bin}/bonsai prebuild -h 2>&1", 1)
  end
end
