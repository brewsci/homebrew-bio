class Indelible < Formula
  # cite Fletcher_2009: "https://doi.org/10.1093/molbev/msp098"
  desc "Flexible Simulator of Biological Sequence Evolution"
  homepage "https://tracker.debian.org/pkg/indelible"
  url "http://archive.ubuntu.com/ubuntu/pool/universe/i/indelible/indelible_1.03.orig.tar.xz"
  sha256 "60ed2a8fd50608a56a92f708a117194d4a6d23a53e55ecc27bf76e5fdf470c80"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "b0e0bdb1d36361acd34e6aeeae0b5c30da04e27175ac8d114d7aa60abbc3675e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "21419cb7b8262602bfada3b67fa5c1b0009814a978ef67e4987b11f9c1659330"
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
