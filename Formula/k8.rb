class K8 < Formula
  desc "Javascript shell based on Google's V8 Javascript engine"
  homepage "https://github.com/attractivechaos/k8"
  url "https://github.com/attractivechaos/k8/releases/download/0.2.5/k8-0.2.5.tar.bz2"
  sha256 "a937ac44532e042cd89ac743647b592c21cfcf31679e39e5f362e81034d93d18"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5e8e387a90767bcc08dab8c7ada0fef01771cb255ef22a9077a2b07dca51522f" => :catalina
    sha256 "1da19c67eeeea17d824875adf5847354fdea7599c286a637b8342a7e4f83dfa4" => :x86_64_linux
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
