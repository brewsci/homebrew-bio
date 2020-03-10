class Bifrost < Formula
  # cite Holley_2019: "https://doi.org/10.1101/695338"
  desc "Highly parallel build/index of coloured/compacted de Bruijn graphs"
  homepage "https://github.com/pmelsted/bifrost"
  url "https://github.com/pmelsted/bifrost/archive/v1.0.1.tar.gz"
  sha256 "a94b230663d44db3ce34630be23790a77218918051fee1725770671e70c68657"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f1f8cddd35acd9bcc2484cb4ceda170b43743fef6e705e72f55f90525511fbcd" => :catalina
    sha256 "0661fb88ce00d23aa5505284e68aedc63eb4922719b06c8af4f49e76aaafdf6e" => :x86_64_linux
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # no way to determine version https://github.com/pmelsted/bifrost/issues/14
    assert_match "bloom", shell_output("#{bin}/Bifrost 2>&1")
  end
end
