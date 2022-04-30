class Freebayes < Formula
  # cite Garrison_2012: "https://arxiv.org/abs/1207.3907v2"
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      tag:      "v1.3.6",
      revision: "084dce52e54af5adbd1e2b0a67f3733dd8bfddc0"
  license "MIT"
  head "https://github.com/ekg/freebayes.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "04d29c063def9219df5ae557876fdd4095cfde34e540e2a28acd1109a79f34bf"
    sha256 cellar: :any, x86_64_linux: "07f3e4dd360c93efb848b5e4a420a0b32f8ce85d85f21652975aa382716657a9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "parallel"
  depends_on "python"
  depends_on "vcflib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "meson", *std_meson_args, "build/", "--prefix=#{prefix}", "--buildtype=release"
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end

    bin.install "scripts/freebayes-parallel"

    rm "scripts/bgziptabix"
    rm "scripts/vcffirstheader"
    rm "scripts/update_version.sh"
    pkgshare.install Dir["scripts/*"]
  end

  def caveats
    <<~EOS
      The freebayes scripts can be found in
      #{HOMEBREW_PREFIX}/share/freebayes/
    EOS
  end

  test do
    assert_match "polymorphism", shell_output("#{bin}/freebayes --help 2>&1")
    assert_match "chunks", shell_output("#{bin}/freebayes-parallel 2>&1")
  end
end
