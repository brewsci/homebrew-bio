class Freebayes < Formula
  # cite Garrison_2012: "https://arxiv.org/abs/1207.3907v2"
  desc "Bayesian variant discovery and genotyping"
  homepage "https://github.com/ekg/freebayes"
  url "https://github.com/ekg/freebayes.git",
      tag:      "v1.3.6",
      revision: "084dce52e54af5adbd1e2b0a67f3733dd8bfddc0"
  license "MIT"
  revision 1
  head "https://github.com/ekg/freebayes.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_sonoma: "513d0c42e50d6580d73822ce3235d18790f3937da86864f4ef4190bf324cde60"
    sha256 cellar: :any, ventura:      "ecaccfe6f2e999c9724693d0e2deacbc83c9362b5517befc9a7bb526a46fe584"
    sha256               x86_64_linux: "6c5f7bc0d5ce63192706e005f47bc7cf9f142b8481a54fdbe31a256931f5ee55"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "parallel"
  depends_on "python@3.12"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # fix build error: ‘numeric_limits’ is not a member of ‘std’
    if OS.linux?
      inreplace "intervaltree/IntervalTree.h",
                "#include <cassert>",
                "#include <cassert>\n#include <limits>\n#include <utility>"
    end
    system "meson", *std_meson_args, "build/", "--prefix=#{prefix}"
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
