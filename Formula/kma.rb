class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.3.0.zip"
  sha256 "c87a0d8a592af39dc9847b92efdd5bb3eb7e1b7a4fcdfa9e40ac113d104526f9"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4af45d0e259a34fc5310f606984abac3b2829e947e34574a881def37baa8892f" => :catalina
    sha256 "995c5b676345eaff8f4951040670bfcc77baf77ab95f4ac22cdd26b68a58b6d6" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install %w[kma kma_index kma_shm]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kma -v 2>&1")
  end
end
