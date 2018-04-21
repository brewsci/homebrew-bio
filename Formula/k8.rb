class K8 < Formula
  desc "Javascript shell based on Google's V8 Javascript engine"
  homepage "https://github.com/attractivechaos/k8"
  url "https://github.com/attractivechaos/k8/releases/download/v0.2.4/k8-0.2.4.tar.bz2"
  sha256 "da8a99c7f1ce7f0cb23ff07ce10510e770686b906d5431442a5439743c0b3c47"

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
