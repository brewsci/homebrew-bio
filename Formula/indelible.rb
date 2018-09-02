class Indelible < Formula
  # cite Fletcher_2009: "https://doi.org/10.1093/molbev/msp098"
  desc "Flexible Simulator of Biological Sequence Evolution"
  homepage "http://abacus.gene.ucl.ac.uk/software/indelible/"
  url "http://abacus.gene.ucl.ac.uk/software/indelible/EFBKqHdv0v7qir6CyeHgqaz/INDELibleV1.03.tar.gz"
  sha256 "6b74cbe0d3ce202e99d04282a87b564449ab935c66480f20665f1fb4102721a6"

  def install
    cd "src" do
      # MersenneTwister.h:326:19: error: 'getpid' was not declared in this scope
      inreplace "MersenneTwister.h", "<stdio.h>", "<unistd.h>"
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
