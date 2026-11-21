class Indelible < Formula
  # cite Fletcher_2009: "https://doi.org/10.1093/molbev/msp098"
  desc "Flexible Simulator of Biological Sequence Evolution"
  homepage "https://tracker.debian.org/pkg/indelible"
  url "http://archive.ubuntu.com/ubuntu/pool/universe/i/indelible/indelible_1.03.orig.tar.xz"
  sha256 "60ed2a8fd50608a56a92f708a117194d4a6d23a53e55ecc27bf76e5fdf470c80"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6c03e021fa79353e5aead410c8c5d810020d52f42cc01b6285fb2436f0a9577"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af8338e6e84a1613a219c2d99aa34dfc33b94d468f6bf3b9d5cc84681421b792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80c9e96221f4430dc8fa380dec425eb3d97c585c368ce4d7e1ac8b2d9c4cd166"
    sha256 cellar: :any,                 x86_64_linux:      "2c27fece3f5e850985562b3fd637daf30494fe5800d0ad71ba49b3ff0c7a4079"
  end

  def install
    cd "src" do
      # MersenneTwister.h:326:19: error: 'getpid' was not declared in this scope
      inreplace "MersenneTwister.h", "<stdio.h>", "<unistd.h>"
      # paml.cpp: error: reference to 'identity' is ambiguous
      # https://bugs.debian.org/1143661
      inreplace "paml.cpp", "identity (", "identity_matrix ("
      exe = "indelible"
      system ENV.cxx, "-o", exe, "indelible.cpp"
      bin.install exe
    end
    pkgshare.install Dir["help/*"]
  end

  test do
    assert_match "CONTROL FILE", shell_output("#{bin}/indelible < /dev/null 2>&1", 255)
  end
end
