class Fasta < Formula
  # cite Pearson_1990: "https://doi.org/10.1016/0076-6879(90)83007-V"
  desc "Classic FASTA sequence alignment suite"
  homepage "https://fasta.bioch.virginia.edu/"
  url "https://github.com/wrpearson/fasta36/archive/refs/tags/v36.3.8i_14-Nov-2020.tar.gz"
  version "36.3.8i"
  sha256 "b4b1c3c9be6beebcbaf4215368e159d69255e34c0bdbc84affa10cdb473ce008"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:fasta[._-])?v?(\d+(?:\.\d+)+[a-z]?)(?:[._-]|["' >])}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e16e8e21c5a0e8a369467e8f7aaeb639cc0b9c5555af61317dcc09056b170ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f9c2fc37ac0257c336c3a9c20482f539a1388ace02be11272ee45f5f95409e"
    sha256 cellar: :any_skip_relocation, ventura:       "4595e061ba574f46dd3f570d1a8e192db7cae0f22b83de5b58b45c636ddf66b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e40109901d19b8cbf13f5a7ff80fe941934bc077f6749226bee518858a98db"
  end

  uses_from_macos "zlib"

  def install
    bin.mkpath
    arch = if OS.mac?
      Hardware::CPU.arm? ? "os_x_arm64" : "os_x86_64"
    else
      "linux64_sse2"
    end
    system "make", "-C", "src", "-f", "../make/Makefile.#{arch}"
    rm "bin/README"
    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "scripts", "test", "psisearch2", "data", "misc"
  end

  test do
    assert_match version.to_s.gsub(/.\d+.\d+.\d+$/, ""), shell_output("#{bin}/fasta36 -h 2>&1")
  end
end
