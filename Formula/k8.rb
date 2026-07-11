class K8 < Formula
  desc "Javascript shell based on Google's V8 Javascript engine"
  homepage "https://github.com/attractivechaos/k8"
  url "https://github.com/attractivechaos/k8/releases/download/v1.2/k8-1.2.tar.bz2"
  sha256 "a86b160a82f3233a21235d21170f3719a600dbd96bf1ec705a6eb57d770953c9"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "5e8e387a90767bcc08dab8c7ada0fef01771cb255ef22a9077a2b07dca51522f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1da19c67eeeea17d824875adf5847354fdea7599c286a637b8342a7e4f83dfa4"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    # The bundled Linux binary is dynamically linked against libz and would
    # otherwise resolve to the host's /lib, failing `brew linkage --test`.
    # zlib-ng-compat provides libz.so.1 so it resolves to the brewed copy.
    depends_on "zlib-ng-compat"
  end

  def install
    exe = OS.mac? ? "k8-#{Hardware::CPU.arch}-Darwin" : "k8-#{Hardware::CPU.arch}-Linux"
    bin.install exe => "k8"
    if OS.linux?
      # The prebuilt binary is NEEDED libz.so.1; point its rpath at the
      # keg-only zlib-ng-compat lib so `brew linkage --test` resolves the
      # brewed libz instead of the host's /lib/x86_64-linux-gnu/libz.so.1.
      system "patchelf",
             "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
             "--set-rpath", "#{formula_opt_lib("zlib-ng-compat")}:#{HOMEBREW_PREFIX}/lib",
             bin/"k8"
    end
    pkgshare.install "scripts/k8.js"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k8 -v")
  end
end
