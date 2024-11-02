class Mustang < Formula
  # cite Konagurthu_2006: "https://doi.org/10.1002/prot.20921"
  desc "Multiple structural alignment algorithm"
  homepage "https://lcb.infotech.monash.edu/mustang/"
  url "https://lcb.infotech.monash.edu/mustang/mustang_v3.2.4.tgz"
  sha256 "c05e91c955f491a1fddc404a36ef963b057fd725bcc6d22ef6df1c23b26ce237"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1390619429efced942ed1a148980f8f94f8c147fc46f5da25de2f911eca6d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5559c4e4b52c230816b9809fdea89ab995d4f7ae8416a8a4abe14aeb7dce9133"
    sha256 cellar: :any_skip_relocation, ventura:       "b3ca4c2cf4e16e09468e3a5c07054978679845a4f795c570e7e48ee2affe7371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f2be20067e509d8a022fc2b8d544a953a36742ab3d1c6bb2de0d7a19a88cc0"
  end

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "-traditional", "" if OS.mac?
    inreplace "Makefile", "mustang-#{version}", "mustang"
    system "make"
    bin.install "bin/mustang"
    man1.install "man/mustang.1"
  end

  test do
    assert_match "A MUltiple STuructural", shell_output("#{bin}/mustang --help")
  end
end
