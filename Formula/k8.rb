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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55dd73abbe8e7cea04676890777d631a0418e97f937f5e596e946dd61336b782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55dd73abbe8e7cea04676890777d631a0418e97f937f5e596e946dd61336b782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55dd73abbe8e7cea04676890777d631a0418e97f937f5e596e946dd61336b782"
    sha256 cellar: :any,                 x86_64_linux:  "2381a30716e06ae41a8e32f9e002ae830be11ee169a9d200c527524ed8306d73"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    # The bundled Linux binary is dynamically linked against libz and would
    # otherwise resolve to the host's /lib, failing `brew linkage --test`.
    # zlib-ng-compat provides libz.so.1 so it resolves to the brewed copy.
    depends_on "zlib-ng-compat" # provides libz.so.1
  end

  def install
    exe = OS.mac? ? "k8-#{Hardware::CPU.arch}-Darwin" : "k8-#{Hardware::CPU.arch}-Linux"
    bin.install exe => "k8"
    if OS.linux?
      # The prebuilt binary is NEEDED libz.so.1. Symlink the brewed
      # zlib-ng-compat copy into libexec (which, unlike lib, is not linked into
      # the shared prefix, so it cannot collide with zlib-ng-compat's own
      # libz.so.1) and point the rpath at it with a relative $ORIGIN entry.
      # This satisfies `brew linkage --test` without leaving any
      # HOMEBREW_PREFIX path in the ELF, so `brew bottle` skips its rpath
      # relocation entirely. That relocation runs the vendored patchelf.rb,
      # which crashes (split_index) on this binary's segment layout; every
      # absolute-rpath variant hit that bug.
      (libexec/"lib").install_symlink formula_opt_lib("zlib-ng-compat")/"libz.so.1"
      system "patchelf", "--set-rpath", "$ORIGIN/../libexec/lib", bin/"k8"
    end
    pkgshare.install "scripts/k8.js"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/k8 -v")
  end
end
