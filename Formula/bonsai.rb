class Bonsai < Formula
  desc "Ultrafast, flexible taxonomic analysis and classification"
  homepage "https://github.com/dnbaker/bonsai"
  url "https://github.com/dnbaker/bonsai/archive/v0.3.tar.gz"
  sha256 "f89efdf87c4d4a20bf3b8d4e9a11120b44b2b6b3055698c1e48d7790088618b3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "189b70f92aa7b714bc645f5ab759646e0871181a8a6b463dfd3fe11b989fc300" => :sierra
    sha256 "13dd340ff0ff41c70d77d01e9e9e54a90783d98409492428861fbfea31f02762" => :x86_64_linux
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
