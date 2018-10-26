class K8 < Formula
  desc "Javascript shell based on Google's V8 Javascript engine"
  homepage "https://github.com/attractivechaos/k8"
  url "https://github.com/attractivechaos/k8/releases/download/v0.2.4/k8-0.2.4.tar.bz2"
  sha256 "da8a99c7f1ce7f0cb23ff07ce10510e770686b906d5431442a5439743c0b3c47"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f370eb8ea7d3c82bb72e576d837d80af5ba6ab43e5e005618a90bfa3645237d0" => :sierra
    sha256 "b5bef3ab83d502b61c846d4bf3fe757b63887eea61acb15bd6ce2296ae448a05" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "zlib"
  end

  def install
    exe = OS.mac? ? "k8-Darwin" : "k8-Linux"
    bin.install exe => "k8"
    if OS.linux?
      system "patchelf",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX/"lib",
        bin/"k8"
    end
    pkgshare.install "k8.js"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k8 -v")
  end
end
